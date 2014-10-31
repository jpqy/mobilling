class ErrorReport < EdtFile
  validate :memo
  has_many :claims, inverse_of: :remittance_advice

  def filename_character
    'P'
  end

  def memo
    return if @memo && @memo == contents
    @memo = contents
    @records = Record.process_batch(contents)
    @claims = []
    @claim_header_records = {}
    @claim_rmb_records = {}
    @claim_attn = {}
    @item_records = {}
    @premium_records = {}
    @message_text = ""
    @balance_records = []
    @accounting_records = []
    @unmatched_records = []
    @overtime_records = []
    @message_records = {}
    current_claim = nil
    @records.each {|record|
      case
      when record.kind_of?(ErrorReportHeader)
        self.user = User.find_by(provider_number: record['Health Care Provider'])
        if self.user
          @header = record
        else
          @unmatched_records << record
        end
      when record.kind_of?(ErrorReportClaimHeader)
        puts 'claim header', record.fields
        current_claim = Claim.find_by(user_id: user_id, number: record['Accounting Number'].to_i)
        if current_claim.nil?
          @unmatched_records << record
        else
          @claims << current_claim
          @claim_header_records[current_claim.id] = record
          @item_records[current_claim.id] ||= []
          @premium_records[current_claim.id] ||= []
          @message_records[current_claim.id] ||= []
        end
      when record.kind_of?(ErrorReportClaimHeaderRMB)
        if current_claim
          @claim_rmb_records[current_claim.id] = record
        else
          @unmatched_records << record
        end
      when record.kind_of?(ErrorReportItem)
        puts 'claim item', record.fields
        claim_item = nil
        if not current_claim.nil?
          daily_index = nil
          premium_index = nil
          found = nil
          current_claim.submitted_details['daily_details'].each_with_index do |daily, i|
            if daily['Service Date'] == record['Service Date']
              if daily['Service Code'] == record['Service Code']
                @item_records[current_claim.id][i] = record
                if !record['Explanatory Code'].blank?
                  @claim_attn[current_claim.id] = true
                end
                found = true
              else
                daily['premiums'].each_with_index do |premium, j|
                  @premium_records[current_claim.id][i] ||= []
                  @premium_records[current_claim.id][i][j] = record
                  if !record['Explanatory Code'].blank?
                    @claim_attn[current_claim.id] = true
                  end
                  found = true
                end
              end
            end
          end
          if !found
            @unmatched_records << record
          end
        else
          @unmatched_records << record
        end
      when record.kind_of?(ErrorReportExplanationCodeMessage)
        if current_claim
          @message_records[current_claim.id] << record
        else
          @unmatched_records << record
        end
      when record.kind_of?(ErrorReportTrailer)
        true
      else
        errors.add_to_base "Unknown record type: #{record.class}"
      end
    }
  end

  def messageFor(record)
    messages = []
    if record['Explanatory Code'] != '  '
      code = ErrorRecordExplanatoryCode.find_by(code: record['Explanatory Code'])
      if code
        messages << "#{code.code}: #{code.name}"
      end
    end
    (1..6).each do |n|
      if record["Error Code #{n}"] != '   '
        messages << ErrorRecordRejectionConditions.where(code: record['Explanatory Code']).map do |cond|
          "#{cond.code}: #{cond.name}"
        end.join("\n")
      end
    end
    messages.join("\n")
  end

  def process!
    memo
    if !@unmatched_records.empty?
      return "Could not find records for:\n"+@unmatched_records.join("\n")
    end

    @claims.each do |claim|
      if @claim_records[claim.id]
        claim.status = @claim_attn[claim.id] ? 'agent_attention' : 'done'
        claim.files << self
        claim.details['daily_details'].each_with_index do |daily, i|
          record = @item_records[claim.id][i]
          if record
            if !record['Explanatory Code'].blank?
              daily['message'] = messageFor(record)
            end
          end

          (daily['premiums'] || []).each_with_index do |premium, j|
            record = @premium_records[claim.id][i][j]
            if record
              premium['paid'] = record['Amount Paid']
              if !record['Explanatory Code'].blank?
                premium['message'] = messageFor(record)
              end
            end
          end
        end
        claim.save!
      end
    end
    save!
    nil
  end

  def unmatched_records
    memo
    @unmatched_records
  end

  def claim_details(claim)
    memo
    return nil if @claim_records[claim.id].nil?
    { 'items' => @item_records[claim.id].map.with_index do |record, i|
        { 'premiums' => (@premium_records[claim.id][i] || []).map(&:fields) }.merge(record.fields)
    end }.merge(@claim_records[claim.id].fields)
  end
end

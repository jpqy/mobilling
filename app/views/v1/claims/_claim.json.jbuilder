json.id                         claim.id
json.status                     claim.status
json.photo_id                   claim.photo_id
json.number                     claim.number
json.specialty                  claim.details["specialty"]
json.patient_name               claim.details["patient_name"]
json.hospital                   claim.details["hospital"]
json.referring_physician        claim.details["referring_physician"]
json.diagnoses                  claim.details["diagnoses"]
json.most_responsible_physician claim.details["most_responsible_physician"]
json.procedure_on               claim.details["procedure_on"]
json.admission_on               claim.details["admission_on"]
json.first_seen_on              claim.details["first_seen_on"]
json.first_seen_consult         claim.details["first_seen_consult"]
json.last_seen_on               claim.details["last_seen_on"]
json.last_seen_discharge        claim.details["last_seen_discharge"]
json.icu_transfer               claim.details["icu_transfer"]
json.consult_type               claim.details["consult_type"]
json.consult_time_in            claim.details["consult_time_in"]
json.consult_time_out           claim.details["consult_time_out"]
json.consult_premium_visit      claim.details["consult_premium_visit"]
json.consult_premium_first      claim.details["consult_premium_first"]
json.consult_premium_travel     claim.details["consult_premium_travel"]
json.daily_details claim.details["daily_details"] do |daily_detail|
  json.day           daily_detail["day"]
  json.code          daily_detail["code"]
  json.time_in       daily_detail["time_in"]
  json.time_out      daily_detail["time_out"]
  json.autogenerated daily_detail["autogenerated"]
  json.code          daily_detail["code"]
  json.fee           daily_detail["fee"]
  json.premiums      daily_detail["premiums"] do |premium|
    json.code          premium["code"]
    json.fee           premium["fee"]
    json.units         premium["units"]
  end
end
json.comments claim.comments do |comment|
  json.body       comment.body
  json.user_name  comment.user.try(:name)
  json.created_at comment.created_at
end
json.created_at                 claim.created_at
json.updated_at                 claim.updated_at

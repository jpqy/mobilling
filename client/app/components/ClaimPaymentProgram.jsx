import ClaimFormGroup from '../components/ClaimFormGroup';
import ClaimInputWrapper from '../components/ClaimInputWrapper';
import RadioSelect from '../components/RadioSelect';

export default React.createClass({
  render: function() {
    var options = {};
    var value = this.props.store.payment_program;
    if (this.props.store.patient_province) {
      options['HCP'] = 'OHIP';
      value = value || 'HCP';
    } else {
      options['RMB'] = 'Reciprocal';
      value = value || 'RMB';
    }
    options['WCB'] = 'WSIB';
    return (
      <ClaimFormGroup label="Payment Program">
        <ClaimInputWrapper {...this.props} name="payment_program">
          <RadioSelect {...this.props} value={value} small name="payment_program" options={options} />
        </ClaimInputWrapper>
      </ClaimFormGroup>
    );
  }
});

const AdminClaimForm = require('./AdminClaimForm');
const AdminClaimStatusActions = require('./AdminClaimStatusActions');
const ClaimView = require('./ClaimView');
const { refreshClaim, claimChangeHandler, updateParams } = require('../actions');
const { connect } = require('react-redux');

@connect((state) => state)
class AdminClaimEdit extends React.Component {
  componentDidMount() {
    this.props.dispatch && this.props.dispatch(refreshClaim(this.props.params.id));
  }

  componentDidUpdate(prevProps) {
    if (this.props.params.id !== prevProps.params.id) {
      this.props.dispatch(refreshClaim(this.props.params.id));
    }
  }

  loadClaim(id) {
    this.props.dispatch(refreshClaim(id));
    this.props.dispatch(updateParams({id}));
  }

  render() {
    const claim = this.props.claimStore.claims[this.props.params.id];
    if (!claim) return false;
    const handler = claimChangeHandler.bind(null, this.props.dispatch, claim);
    var claimHref = function(id) {
      return "/admin/claims/"+id+"/edit";
    };

    if (["saved", "for_agent", "doctor_attention"].indexOf(claim.status) >= 0) {
      return (
        <div className="form-horizontal">
          <AdminClaimForm {...this.props} store={claim} claim={claim} onChange={handler} claimHref={claimHref} />
          <AdminClaimStatusActions {...this.props} store={claim} claim={claim} onChange={handler} claimHref={claimHref} stack={this.props.claimStore.stack} loadClaim={this.loadClaim.bind(this)}/>
        </div>
      );
    } else {
      return (
        <div className="form-horizontal">
          <ClaimView {...this.props} store={claim} claim={claim} onChange={handler} claimHref={claimHref} />
          <AdminClaimStatusActions {...this.props} store={claim} claim={claim} onChange={handler} claimHref={claimHref} stack={this.props.claimStore.stack} loadClaim={this.loadClaim.bind(this)}/>
        </div>
      );
    }
  }
};

module.exports = AdminClaimEdit;

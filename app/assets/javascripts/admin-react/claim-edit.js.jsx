var ClaimEdit = React.createClass({
  getInitialState: function() {
    return {
      id: this.props.id
    };
  },

  mixins: [
    Fynx.connect(claimStore, 'store'),
  ],

  loadClaim: function(id) {
    claimActions.load(id);
    this.setState({id: id});
  },

  render: function() {
    if (["saved", "for_agent", "doctor_attention"].indexOf(this.state.store.getIn([this.state.id, 'status'])) >= 0) {
      return (
        <div className="form-horizontal">
          <ClaimForm {...this.props} actions={claimActionsFor(this.state.id)} store={this.state.store.get(this.state.id)} loadClaim={this.loadClaim} />
          <ClaimStatusActions {...this.props} actions={claimActionsFor(this.state.id)} store={this.state.store.get(this.state.id)} loadClaim={this.loadClaim} />
        </div>
      );
    } else {
      return (
        <div className="form-horizontal">
          <ClaimView {...this.props} store={this.state.store.get(this.state.id)} />
          <ClaimStatusActions {...this.props} actions={claimActionsFor(this.state.id)} store={this.state.store.get(this.state.id)} loadClaim={this.loadClaim} />
        </div>
      );
    }
  }
});


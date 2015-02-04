var ClaimForm = React.createClass({
  handleChange: function(ev) {
    this.props.actions.updateFields([[[ev.target.name], ev.target.value]]);
  },

  checkboxChanged: function(ev) {
    this.props.actions.updateFields([[[ev.target.name], ev.target.checked]]);
  },

  render: function() {
    return (
      <div>
        <fieldset>
          <ClaimStaticOptional {...this.props} name="number" />
          <ClaimStaticOptional {...this.props} name="status" />
        </fieldset>
        <fieldset>
          <legend>Patient</legend>

          <ClaimPatient {...this.props} handleChange={this.handleChange}/>
        </fieldset>

        <fieldset>
          <legend>Claim</legend>
          <ClaimTab {...this.props} handleChange={this.handleChange} />
        </fieldset>

        { this.props.store.get('template') === 'full' &&
         <fieldset>
          <legend>Consult</legend>
          <ConsultTab {...this.props} handleChange={this.handleChange}/>
         </fieldset>
        }

        <fieldset>
          <legend>Items</legend>
          <ItemsTab {...this.props} handleChange={this.handleChange}/>
        </fieldset>

        <fieldset>
          <CommentsTab {...this.props} handleChange={this.handleChange}/>
        </fieldset>

      </div>
    );
  },

});

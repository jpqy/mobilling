var EmptyHeader = React.createClass({
  mixins: [
    Fynx.connect(globalStore, 'globalStore'),
  ],

  render: function() {
    return (
      <div>
        <Navbar fixedTop>
          <Nav>
            <NavItem href={window.ENV.CORDOVA ? '#' : "http://mo-billing.ca"}>Mo-Billing</NavItem>
          </Nav>
        </Navbar>
        <Notice/>
      </div>
    );
  }
});

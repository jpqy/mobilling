import _ from 'underscore';
import React, {Text, View, ScrollView, TouchableOpacity} from 'react-native';
const styles = require('./styles');
const dollars = require('../data/dollars');
import claimTotal from '../data/claimTotal';
import Toolbar from './Toolbar.jsx';

export default class ClaimsScreen extends React.Component {
  componentWillMount() {
    this.props.actions.refreshClaimList();
  }

  handlePress(id) {
    this.props.navigator.push({screen: 'Claim', id});
  }

  render() {
    return <View style={styles.container}>
      <Toolbar title="Claims"/>
      <ScrollView style={styles.full} contentContainerStyle={styles.claimList}>
      {_.map(this.props.claimStore.claimList, (id) => {
        var claim = this.props.claimStore.claims[id];
        if (!claim) return false;
        return <TouchableOpacity key={id} onPress={this.handlePress.bind(this, id)}>
          <View style={styles.claimListRow}>
            <Text style={styles.claimListField}>{claim.number}</Text>
            <Text style={styles.claimListField}>{claim.service_date}</Text>
            <Text style={styles.claimListField}>{claim.patient_name}</Text>
            <Text style={styles.claimListField}>{dollars(claim.total_fee || claimTotal(claim))}</Text>
          </View>
        </TouchableOpacity>;
      })}
      </ScrollView>
    </View>;
  }
};

import s from 'underscore.string';
import React, {View} from 'react-native';
import styles from './styles';
import FloatingTextInput from './FloatingTextInput.jsx';
import InputWarnings from './InputWarnings.jsx';

export default class TextInputGroup extends React.Component {
  focus() {
    this.refs.input.focus();
  }

  render() {
    const value = this.props.value !== undefined ? this.props.value : this.props.store[this.props.name];
    return <View>
      <FloatingTextInput
        {...this.props}
        ref="input"
        placeHolder={this.props.label || s.humanize(this.props.name)}
        value={value}
        onBlur={(ev, val) => this.props.onUpdate({[this.props.name]: val})}
      />
      <InputWarnings {...this.props} />
    </View>;
  }
};

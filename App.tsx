import React from 'react';
import {Text, SafeAreaView, Button} from 'react-native';

const App = () => {
  const onPress = () => {
    console.log('test');
  };

  return (
    <SafeAreaView>
      <Text>Fingerprint iOS POC</Text>
      <Button
        title="Click to invoke your native module!"
        color="#841584"
        onPress={onPress}
      />
    </SafeAreaView>
  );
};

export default App;

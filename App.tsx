import React from 'react';
import {Text, SafeAreaView, Button, NativeModules} from 'react-native';

const {FingerprintModuleIOS} = NativeModules;

const App = () => {
  const onPress = () => {
    FingerprintModuleIOS.createFingerprintEvent('testName', 'testLocation');
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

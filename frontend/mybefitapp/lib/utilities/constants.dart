class Constants {
  static Map<String, dynamic> getConstant() {
    const startingIp = 'http://192.168.100.2:5000';
    final factoryConstant = {
      'url': startingIp,
      'userList': '$startingIp/userprofile',
      'stepList': '$startingIp/steps',
      'bodyList': '$startingIp/measurements',
    };
    return factoryConstant;
  }
}

class Constants {
  static Map<String, dynamic> getConstant() {
    const startingIp = 'https://doubtful-underwear-hen.cyclic.app';
    final factoryConstant = {
      'url': startingIp,
      'userList': '$startingIp/userprofile',
      'stepList': '$startingIp/steps',
      'bodyList': '$startingIp/measurements',
    };
    return factoryConstant;
  }
}

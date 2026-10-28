enum FacilityType {
  teachingMaternity,
  districtHospital,
  areaHospital,
  communityHealthCenter,
  primaryHealthCenter,
  urbanPrimaryHealthCenter
}

class HealthcareFacility {
  final String id;
  final String name;
  final String nameTe;
  final FacilityType type;
  final String district;
  final String mandal;
  final String address;
  final String contactNumber;
  final String emergencyNumber;
  final bool has24x7Delivery;
  final bool hasCSectionOt;
  final bool hasSncuNicu;
  final bool hasBloodBank;
  final bool hasFreeUltrasound;
  final bool hasAmmaVodi102;
  final double distanceKm;

  HealthcareFacility({
    required this.id,
    required this.name,
    required this.nameTe,
    required this.type,
    required this.district,
    required this.mandal,
    required this.address,
    required this.contactNumber,
    this.emergencyNumber = '108',
    this.has24x7Delivery = true,
    this.hasCSectionOt = false,
    this.hasSncuNicu = false,
    this.hasBloodBank = false,
    this.hasFreeUltrasound = false,
    this.hasAmmaVodi102 = true,
    this.distanceKm = 2.5,
  });

  String get typeLabel {
    switch (type) {
      case FacilityType.teachingMaternity:
        return 'Govt Maternity Teaching Hospital';
      case FacilityType.districtHospital:
        return 'District Hospital (DH)';
      case FacilityType.areaHospital:
        return 'Area Hospital (AH)';
      case FacilityType.communityHealthCenter:
        return 'Community Health Centre (CHC)';
      case FacilityType.primaryHealthCenter:
        return 'Primary Health Centre (PHC)';
      case FacilityType.urbanPrimaryHealthCenter:
        return 'Urban Primary Health Centre (UPHC)';
    }
  }

  String get typeLabelTe {
    switch (type) {
      case FacilityType.teachingMaternity:
        return 'ప్రభుత్వ ప్రసూతి బోధనాసుపత్రి';
      case FacilityType.districtHospital:
        return 'జిల్లా ప్రధాన ఆసుపత్రి';
      case FacilityType.areaHospital:
        return 'ఏరియా ఆసుపత్రి';
      case FacilityType.communityHealthCenter:
        return 'సామాజిక ఆరోగ్య కేంద్రం (CHC)';
      case FacilityType.primaryHealthCenter:
        return 'ప్రాథమిక ఆరోగ్య కేంద్రం (PHC)';
      case FacilityType.urbanPrimaryHealthCenter:
        return 'పట్టణ ప్రాథమిక ఆరోగ్య కేంద్రం (UPHC)';
    }
  }
}

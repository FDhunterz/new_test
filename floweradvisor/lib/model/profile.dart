class ProfileModel{
  String? nama, image;

  ProfileModel({this.image,this.nama}) {
    image ??= 'https://neweralive.na/storage/images/2023/may/lloyd-sikeba.jpg';
  }
}
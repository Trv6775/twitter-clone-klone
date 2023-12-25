class AppwriteConstants {
  static const String databaseId = '6566a3af4989d9285790';
  static const String projectId = '6566a1ffcf03bba75417';
  static const String usersCollectionId = '65715b9ff22d5ab3f932';
  static const String tweetCollectionId = '657aaf8ac10a52f1a183';
  static const String imagesBucketId = '658155c431fd57b37d10';
  static const String endpoint = 'https://cloud.appwrite.io/v1';

  static String imageUrl(String imageId) =>
      '$endpoint/storage/buckets/$imagesBucketId/files/$imageId/view?project=$projectId&mode=admin';
}

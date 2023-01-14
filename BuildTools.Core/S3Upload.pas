namespace BuildTools.Core;

uses
  Amazon,
  Amazon.Runtime,
  Amazon.Runtime.CredentialManagement,
  System.IO, System.Net;

type

  S3Upload = public class
  private
  protected
  public

    class method UploadToBucketAsync(filename:String; bucketName:String):Task<String>;
    begin
      var s3Uri:String := nil;
      var sharedFile := new SharedCredentialsFile;

      var profile:CredentialProfile;

      if (sharedFile.TryGetProfile('default', out profile)) then
      begin
        var credentials:AWSCredentials;

        if (AWSCredentialsFactory.TryGetAWSCredentials(profile, sharedFile, out credentials))then
        begin


          if (not File.Exists(filename)) then
          begin
            Console.WriteLine($'File {filename} does not exist');
            exit;
          end;

          var localFile := new FileInfo(filename);


          var key := Path.GetFileNameWithoutExtension(filename);

          Console.WriteLine($'upload ');
          Console.WriteLine($'{filename} ');
          Console.WriteLine($'to ');
          Console.WriteLine($'bucket {bucketName} ');
          Console.WriteLine($'using key {key} ');


          if(localFile.Exists)then
          begin


            var helpers := new S3Helpers(credentials, RegionEndpoint.USEast2);

            if(not await helpers.FileExists(bucketName, key))then
            begin

              var putResponse := await helpers.PutObjectAsync(localFile, bucketName, key);

              if(putResponse.HttpStatusCode = HttpStatusCode.OK)then
              begin
                s3Uri := $'s3://{bucketName}/{key}';
              end
              else
              begin
                Console.WriteLine($'Failed with status code {putResponse.HttpStatusCode}');
              end;

            end
            else
            begin
              Console.WriteLine('File already exists in bucket');
            end;
          end;
        end
        else
        begin
          Console.WriteLine('Unable to load credentials');
        end;

      end
      else
      begin
        Console.WriteLine('Profile doesnt exist');
      end;

      exit s3Uri;
    end;

  end;

end.
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

    class method UploadToBucket(filename:String; bucketName:String);
    begin
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

          Console.WriteLine('Press any key continue, x to quit');

          var cki := Console.ReadKey;

          if(cki.KeyChar <> 'x')then
          begin

            if(localFile.Exists)then
            begin


              var helpers := new S3Helpers(credentials, RegionEndpoint.USEast2);

              if(not await helpers.FileExists(bucketName, key))then
              begin

                var putResponse := await helpers.PutObjectAsync(localFile, bucketName, key);

                if(putResponse.HttpStatusCode = HttpStatusCode.OK)then
                begin
                  Console.WriteLine('Upload was successful');
                  Console.WriteLine($'S3 Uri is s3://{bucketName}/{key}');


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
            end
            else
            begin
              Console.WriteLine('Local file does not exist');
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

    end;

  end;

end.
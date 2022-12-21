namespace S3UploadConsoleApplication;


uses
  Amazon.Runtime.CredentialManagement,
  Amazon.Runtime,
  Amazon.S3,
  Amazon.S3.Model,
  System.Linq,
  System.IO,
  System.Net,
  System.Threading.Tasks;


type
  S3Helpers = public class

  public
    class method FileExists(client:AmazonS3Client; bucket: String; key: String): Task<Boolean>;
    begin

      try
        await client.GetObjectMetadataAsync(bucket, key);
        exit true;
      except
        on ex: AmazonS3Exception do begin
          if String.Equals(ex.ErrorCode, "NotFound") then
          begin
            exit false;
          end;
          raise;
        end;
      end;

      exit false;
    end;

  end;


begin

  var args := Environment.GetCommandLineArgs;

  if(args.Length = 3)then
  begin

    var sharedFile := new SharedCredentialsFile();

    var profile:CredentialProfile;

    if (sharedFile.TryGetProfile('default', out profile)) then
    begin
      var credentials:AWSCredentials;

      if (AWSCredentialsFactory.TryGetAWSCredentials(profile, sharedFile, out credentials))then
      begin

        var client := new AmazonS3Client(credentials);

        var filename:String := args[1];

        if (not File.Exists(filename)) then
        begin
          Console.WriteLine($'File {filename} does not exist');
          exit;
        end;

        var localFile := new FileInfo(filename);

        var bucketName := args[2];

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
            if(not await S3Helpers.FileExists(client, bucketName, key))then
            begin

              var request := new PutObjectRequest;
              request.InputStream := localFile.OpenRead;
              request.BucketName := bucketName;
              request.Key := key;

              var response := await client.PutObjectAsync(request);

              if(response.HttpStatusCode = HttpStatusCode.OK)then
              begin
                Console.WriteLine('Upload was successful');
              end
              else
              begin
                Console.WriteLine($'Failed with status code {response.HttpStatusCode}');
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
end
else
begin
  Console.WriteLine('No command line arguments passed you need 2 filename bucketname');
end;


end.
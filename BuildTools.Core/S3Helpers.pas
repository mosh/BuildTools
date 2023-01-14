namespace BuildTools.Core;

uses
  Amazon,
  Amazon.Runtime,
  Amazon.S3,
  Amazon.S3.Model, System.IO;

type
  S3Helpers = public class
  private
    client:AmazonS3Client;

  public
    constructor(credentials:AWSCredentials; region:RegionEndpoint);
    begin
      client := new AmazonS3Client(credentials, region);
    end;

    method GetObjectMetadataAsync(bucketName:String; key:String):Task<GetObjectMetadataResponse>;
    begin
      var getRequest := new GetObjectMetadataRequest;
      getRequest.BucketName := bucketName;
      getRequest.Key := key;

      exit await client.GetObjectMetadataAsync(getRequest);

    end;

    method PutObjectAsync(localFile:FileInfo;bucketName:String; key:String):Task<PutObjectResponse>;
    begin
      var request := new PutObjectRequest;
      request.InputStream := localFile.OpenRead;
      request.BucketName := bucketName;
      request.Key := key;

      exit await client.PutObjectAsync(request);

    end;

    method FileExists(bucket: String; key: String): Task<Boolean>;
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

end.
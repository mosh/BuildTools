namespace BuildTools.Core;

uses
  System.Text.RegularExpressions;

type
  OutputHelpers = public class
  private
  protected
  public
    //
    // Extract filename from string like Created /folder/filename.zip
    //
    class method ExtractFilename(value:String):String;
    begin
      var x := value.LastIndexOf(YamlHelpers.successText);
      exit value.Substring(x+YamlHelpers.successText.Length).ReplaceLineEndings('');
    end;

    const S3UriText = 'S3 Uri is ';
    const ZipUploadedText = 'Zip uploaded ';

    // Extract Zip uploaded is {filename} S3 Uri is {s3Uri}
    class method ExtractS3Components(value:String):tuple of (filename:String,s3Resource:String);
    begin

      var reg := '(\/.*(?= S3 Uri is s3)|s3:.*)';

      var rx := new Regex(reg, RegexOptions.Compiled or RegexOptions.IgnoreCase);


      // Find matches.
      var matches := rx.Matches(value);

      if(matches.Count=2)then
      begin
        var m1 := matches.Item[0];
        var m2 := matches.Item[1];

        var filename := m1.Value;
        var s3Resource := m2.Value;

        exit (filename, s3Resource);
      end;
      exit (nil, nil);
    end;
  end;

end.
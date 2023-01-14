namespace BuildTools.Core.Tests;

uses
  RemObjects.Elements.EUnit, BuildTools.Core;

type
  YamlHelpersTests = public class(Test)
  private
  protected
  public
    method CheckThatBucketNameIsRetrieved;
    begin
      var value := $'{YamlHelpers.successText} /Users/JohnMoshakis/Documents/develop/Serverless-Oxgene-Lambda/zip/081706b4-49ba-4638-a32e-be7dea66f5cd.zip';

      var bucket := YamlHelpers.RetrieveFirstBucket(value);
      Console.WriteLine(bucket);
    end;
  end;

end.
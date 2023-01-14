namespace BuildTools.Core;

uses
  System.IO,
  System.Text,
  System.Text.RegularExpressions;

type
  YamlHelpers = public class
  private
  protected
  public

    class const successText = 'Created ';

    class method UpdateCodeUri(filename:String; s3Resource:String);
    begin
      var code := 'CodeUri:';
      var newLines := new StringBuilder;

      if(File.Exists(filename))then
      begin
        var lines := File.ReadAllLines(filename);

        for each line in lines do
          begin
          if line.Contains(code) then
          begin
            var x := line.IndexOf(code)+code.Length;

            var replaced := line.Replace(line.Substring(x),$' {s3Resource}');
            newLines.AppendLine(replaced+'');
          end
          else
          begin
            newLines.AppendLine(line);
          end;
        end;

        var backupFilename := Path.ChangeExtension(filename, '.yaml.old');

        if(File.Exists(backupFilename))then
        begin
          Console.WriteLine('Removing old backup');
          File.Delete(backupFilename);
        end;

        Console.WriteLine($'Copying {filename} to {backupFilename}');
        File.Copy(filename, backupFilename);

        if(File.Exists(backupFilename))then
        begin
          Console.WriteLine('Removing existing file');
          File.Delete(filename);
          Console.WriteLine('Writing new file');
          File.WriteAllText(filename, newLines.ToString);
          Console.WriteLine($'Written new file {filename}');
        end
        else
        begin
          Console.WriteLine($'Backup file {backupFilename} could not be created');
        end;

      end
      else
      begin
        Console.WriteLine($'Resource Filename {filename} does not exist');
      end;

    end;

    ///
    /// value should contain a
    ///
    class method RetrieveFirstBucket(value:String):String;
    begin
      var bucketName:String := nil;

      var x := value.LastIndexOf(successText);
      var filename := value.Substring(x+successText.Length);

      var templateName := Path.Combine(Path.GetDirectoryName(filename),'..'+Path.DirectorySeparatorChar);

      if (Directory.Exists(templateName))then
      begin
        var files := Directory.GetFiles(templateName);

        var templateFile := files.FirstOrDefault(f ->
          begin
            var ext := Path.GetExtension(f);
            exit ext = '.yaml';
          end);

        if(String.IsNullOrEmpty(templateFile))then
        begin
          Console.WriteLine('Failed to find template');
        end
        else
        begin
          var text := File.ReadAllLines(Path.Combine(templateName, templateFile));

          var s3Lines := new List<String>;

          for each line in text do
            begin
            if line.Contains('s3://') then
            begin
              s3Lines.Add(line);
            end;
          end;

          if(s3Lines.Any)then
          begin

            var lineToProcess := s3Lines.First;


            var r := new Regex('(?<=s3:\/\/).*', RegexOptions.Compiled or RegexOptions.IgnoreCase);
            var matches := r.Matches(lineToProcess);

            if(matches.Count=1)then
            begin

              var y := matches.Item[0].Value.LastIndexOf('/');

              bucketName := matches.Item[0].Value.Substring(0,y);


            end;



          end;

        end;
      end
      else
      begin
        Console.WriteLine($'Unable to resolve template directory [{templateName}] does not exist');
      end;

      exit bucketName;
    end;

    class method ExtractTemplateNameFromZip(zipFilename:String):String;
    begin
      var templateName := Path.Combine(Path.GetDirectoryName(zipFilename),'..'+Path.DirectorySeparatorChar);

      if (Directory.Exists(templateName))then
      begin
        var files := Directory.GetFiles(templateName);

        var templateFile := files.FirstOrDefault(f ->
          begin
            var ext := Path.GetExtension(f);
            exit ext = '.yaml';
          end);

        exit Path.Combine(templateName,templateFile);
      end;
      exit nil;
    end;
  end;

end.
program SmallTextEditor;

uses
  Vcl.Forms,
  MainUnit in 'MainUnit.pas' {Editor};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TEditor, Editor);
  Application.Run;
end.

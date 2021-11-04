unit MainUnit;

interface

{$H+}

uses
  Winapi.Windows,
  Winapi.Messages,
  System.SysUtils,
  System.Variants,
  System.Classes,
  Vcl.Graphics,
  Vcl.Controls,
  Vcl.Forms,
  Vcl.Dialogs,
  SynEdit,
  Vcl.StdCtrls;

type
  TEditor = class(TForm)
    MainEditor: TSynEdit;
    Label1: TLabel;
    FileHandleBox: TListBox;
    StatusBar: TLabel;
    procedure InitEditor(Sender: TObject);
    procedure HandleFile(Sender: TObject);
    procedure SelectFile(Check:Boolean=True);
    procedure ExcuteKey(Sender: TObject; var Key: Char);
    procedure ChangeContent(Sender: TObject);
    procedure DoneEditor(Sender: TObject; var Action: TCloseAction);
    procedure ShowBox(Sender: TObject);
    procedure ChangeStatus(Sender: TObject; Changes: TSynStatusChanges);
    procedure LeaveMouse(Sender: TObject);
  public
    procedure Dokey(Key:Char);
    procedure SaveNewFile;
    procedure SaveToFile;
    procedure InitNewFile;
    procedure SaveFileWhenExit(Check:Boolean=False);
  end;

var
  Editor: TEditor;
  Fn,LastFn:ShortString;  //For file name
  isSave:Boolean=True;
  MainDis:ShortString;

//other proc and func
procedure TryCreateDir(Name:ShortString);

implementation

procedure TryCreateDir(Name:ShortString);
begin
  try
    CreateDir(Name);
  except
    ShowMessage('ERROR: System can not create directory "'+Name+'" !!');
    ShowMessage('PLEASE MAKE SURE YOU ALLOW THE PROGRAM TO CREATE DIRECTORY IN "'+MainDis+'" !!');
    Editor.Destroy;
    Halt;
  end;
end;

procedure TEditor.ChangeStatus(Sender: TObject; Changes: TSynStatusChanges);
begin
  StatusBar.Caption:=Fn+' (line: '+IntToStr(MainEditor.CaretY)+', column: '+
    IntToStr(MainEditor.CaretX)+') ';
  if isSave then
    StatusBar.Caption:=StatusBar.Caption+'Saved'
  else
    StatusBar.Caption:=StatusBar.Caption+' Unsaved';
end;

procedure TEditor.DoKey(Key:Char);
begin
  case key of
  #19:
    if Fn<>'Untitled' then
      SaveToFile
    else
      SaveNewFile;
  #15:
    begin
      if not isSave then
        SaveFileWhenExit(True);
      SelectFile;
    end;
  #5:
    SelectFile(True);
  #14:
    InitNewFile;
  #17:
    if not isSave then
      SaveFileWhenExit
    else
      begin
        Destroy;
        Halt;
      end;
  #26:
    MainEditor.Undo;
  #25:
    MainEditor.Redo;
  end;
end;

{$R *.dfm}

procedure TEditor.ChangeContent(Sender: TObject);
begin
  Editor.Caption:='*'+Fn+' - Small Text Editor';
  isSave:=False;
end;

procedure TEditor.DoneEditor(Sender: TObject; var Action: TCloseAction);
begin
  if not isSave then
    SaveFileWhenExit;
end;

procedure TEditor.ExcuteKey(Sender: TObject; var Key: Char);
begin
  DoKey(Key);
  StatusBar.Caption:=Fn+' (line: '+IntToStr(MainEditor.CaretY)+', column: '+
    IntToStr(MainEditor.CaretX)+') ';
  if isSave then
    StatusBar.Caption:=StatusBar.Caption+'Saved'
  else
    StatusBar.Caption:=StatusBar.Caption+' Unsaved';
end;

procedure TEditor.HandleFile(Sender: TObject);
begin
  LastFn:=Fn;
  case FileHandleBox.ItemIndex of
  0:
    if Fn<>'Untitled' then
      SaveToFile
    else
      SaveNewFile;
  1:
    begin
      if not isSave then
        SaveFileWhenExit(True);
      SelectFile;
    end;
  2:
    SelectFile(False);
  3:
    InitNewFile;
  4:
    if not isSave then
      SaveFileWhenExit
    else
      begin
        Destroy;
        Halt;
      end;
  end;
  FileHandleBox.Visible:=False;
  StatusBar.Caption:=Fn+' (line: '+IntToStr(MainEditor.CaretY)+', column: '+
    IntToStr(MainEditor.CaretX)+') ';
  if isSave then
    StatusBar.Caption:=StatusBar.Caption+'Saved'
  else
    StatusBar.Caption:=StatusBar.Caption+' Unsaved';
end;

procedure TEditor.InitEditor(Sender: TObject);
var
  UsDis:ShortString;
begin
  if GetEnvironmentVariable('AppData')='' then
    begin
      ShowMessage('System Can not find your %AppData% !');
      if DirectoryExists('C:\') then
        MainDis:='C:\'
      else
        MainDis:=GetCurrentDir;
    end
  else
    begin
      if Not DirectoryExists(MainDis+'\SmallTextEditor') then
        TryCreateDir(MainDis+'\SmallTextEditor');
      MainDis:=GetEnvironmentVariable('AppData')+'\SmallTextEditor';
      if Not DirectoryExists(MainDis+'\SmallTextEditor\TextFiles') then
        TryCreateDir(MainDis+'\SmallTextEditor\TextFiles');
      if Not DirectoryExists(MainDis+'\SmallTextEditor\UserSetting') then
        TryCreateDir(MainDis+'\SmallTextEditor\UserSetting');
    end;
  if ParamStr(1)='' then
  begin
    Fn:='Untitled';
  end
  else
    begin
      Fn:=ParamStr(1);
      try
        MainEditor.Lines.LoadFromFile(FN);
      except
        ShowMessage('Load from file "'+Fn+'" failed');
        Fn:='Untitled';
      end;
    end;
  isSave:=True;
  Editor.Caption:=Fn+' - Small Text Editor';
  StatusBar.Caption:=Fn+' (line: 1, column: 1) Saved';
end;

procedure TEditor.InitNewFile;
begin
  if not isSave then
    SaveFileWhenExit(True);
  Fn:='Untitled';
  isSave:=True;
  MainEditor.Lines.Clear;
  Editor.Caption:=Fn+' - Small Text Editor';
  StatusBar.Caption:=Fn+' (line: '+IntToStr(MainEditor.CaretY)+', column: '+
    IntToStr(MainEditor.CaretX)+') ';
  if isSave then
    StatusBar.Caption:=StatusBar.Caption+'Saved'
  else
    StatusBar.Caption:=StatusBar.Caption+' Unsaved';
end;

procedure TEditor.LeaveMouse(Sender: TObject);
begin
  FileHandleBox.Visible:=False;
end;

procedure TEditor.SaveFileWhenExit(Check:Boolean=False);
var
  td: TTaskDialog;
  tb: TTaskDialogBaseButtonItem;
begin
  td := TTaskDialog.Create(nil);
  try
    td.Caption := 'WARNING!';
    td.Text := 'Do you want to save changes to "'+Fn+'"?';
    td.MainIcon := tdiWarning;
    td.CommonButtons := [];

    tb := td.Buttons.Add;
    tb.Caption := 'Save (Recommended)';
    tb.ModalResult := 100;

    tb := td.Buttons.Add;
    tb.Caption := 'Dont'+#39+'t Save';
    tb.ModalResult := 101;

    tb := td.Buttons.Add;
    tb.Caption := 'Cancel';
    tb.ModalResult := 102;

    td.Execute;
    if td.ModalResult=100 then
      begin
        if Fn<>'Untitled' then
          SaveToFile
        else
          SaveNewFile;
        if not Check then
          begin
            Destroy;
            Halt;
          end;
      end
    else if td.ModalResult=101 then
      begin
        if not Check then
          begin
            Destroy;
            Halt;
          end;
      end
    else
      Abort;

  finally
    td.Free;
  end;
end;

procedure TEditor.SaveNewFile;
var
  SaveDia:TSaveDialog;
  FileName:ShortString;
begin
  LastFn:=Fn;
  SaveDia:=TSaveDialog.Create(nil);
  try
    SaveDia.InitialDir:='C:\';
    SaveDia.Filter:='All files (*.*)|*.*|Text Documents (*.txt)|*.txt';
    SaveDia.DefaultExt:='txt';
    if SaveDia.Execute(Handle) then
      FileName:=SaveDia.FileName;
  finally
    SaveDia.Free;
  end;
  FileName:=FileName+'';
  if FileName<>'' then
    try
      Fn:=FileName;
      MainEditor.Lines.SaveToFile(FN);
      Editor.Caption:=Fn+' - Small Text Editor';
      isSave:=True;
    except
      ShowMessage('Can not save file "'+fn+'"');
      Fn:='Untitled';
      isSave:=False;
    end
  else
    begin
      Fn:='Untitled';
      Editor.Caption:='*'+Fn+' - Small Text Editor';
      isSave:=False;
    end;
end;


procedure TEditor.SaveToFile;
begin
  try
    MainEditor.Lines.SaveToFile(FN);
    Editor.Caption:=Fn+' - Small Text Editor';
    isSave:=True;
  except
    ShowMessage('Can not save file "'+fn+'"');
    Editor.Caption:='*'+Fn+' - Small Text Editor';
    isSave:=False
  end;
end;

procedure TEditor.SelectFile(Check:Boolean=True);
var
  selectedFile: ShortString;
  dlg: TOpenDialog;
begin
  LastFn:=Fn;
  selectedFile := '';
  dlg := TOpenDialog.Create(nil);
  try
    dlg.InitialDir:='C:\';
    dlg.Filter := 'All files (*.*)|*.*|Text Documents (*.txt)|*.txt';
    if dlg.Execute(Handle) then
      selectedFile := dlg.FileName;
  finally
    dlg.Free;
  end;

  if (selectedFile <> '')and(Check) then
    begin
      Fn:=SelectedFile;
      try
        MainEditor.Lines.LoadFromFile(FN);
        isSave:=True;
      except
        ShowMessage('Load form file "'+Fn+'" failed');
        isSave:=False;
        Fn:=LastFn;
      end;
      Editor.Caption:=Fn+' - Small Text Editor';
    end
  else if SelectedFile<>'' then       
    begin
      Fn:=SelectedFile;
      try
        SaveToFile;
      except
        ShowMessage('Can not save file "'+Fn+'"');
        Fn:=LastFn;
      end;
      Editor.Caption:=Fn+' - Small Text Editor';
    end
  else;
end;

procedure TEditor.ShowBox(Sender: TObject);
begin
  if FileHandleBox.Visible then
    FileHandleBox.Visible:=False
  else
    FileHandleBox.Visible:=True;
end;


end.

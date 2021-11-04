object Editor: TEditor
  Left = 0
  Top = 0
  Caption = 'savs'
  ClientHeight = 851
  ClientWidth = 1565
  Color = clSilver
  CustomTitleBar.CaptionAlignment = taCenter
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnClose = DoneEditor
  OnCreate = InitEditor
  DesignSize = (
    1565
    851)
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 8
    Top = 8
    Width = 107
    Height = 23
    Hint = 'Click here to see file handling options'
    Caption = 'File Handle'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -19
    Font.Name = 'Tahoma'
    Font.Style = [fsBold]
    ParentFont = False
    ParentShowHint = False
    ShowHint = True
    OnClick = ShowBox
  end
  object StatusBar: TLabel
    Left = 168
    Top = 823
    Width = 9
    Height = 19
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -16
    Font.Name = 'Consolas'
    Font.Style = []
    ParentFont = False
  end
  object MainEditor: TSynEdit
    Left = 168
    Top = 8
    Width = 1389
    Height = 796
    Anchors = [akLeft, akTop, akRight]
    Color = clWhite
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -17
    Font.Name = 'Consolas'
    Font.Pitch = fpFixed
    Font.Style = []
    Font.Quality = fqClearTypeNatural
    TabOrder = 0
    OnKeyPress = ExcuteKey
    UseCodeFolding = False
    Gutter.Color = clSilver
    Gutter.Font.Charset = DEFAULT_CHARSET
    Gutter.Font.Color = clWindowText
    Gutter.Font.Height = -17
    Gutter.Font.Name = 'Consolas'
    Gutter.Font.Style = []
    Gutter.ShowLineNumbers = True
    Lines.Strings = (
      '')
    OnChange = ChangeContent
    OnStatusChange = ChangeStatus
  end
  object FileHandleBox: TListBox
    Left = 1
    Top = 8
    Width = 161
    Height = 105
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -15
    Font.Name = 'Consolas'
    Font.Style = []
    ItemHeight = 18
    Items.Strings = (
      'Save      Ctrl + S'
      'Open      Ctrl + O'
      'Save as...Ctrl + E'
      'New file  Ctrl + N'
      'Exit      Ctrl + Q')
    ParentFont = False
    TabOrder = 1
    Visible = False
    OnClick = HandleFile
    OnMouseLeave = LeaveMouse
  end
end

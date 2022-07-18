object Form1: TForm1
  Left = 0
  Top = 0
  Caption = 'Teste de Menu Lateral'
  ClientHeight = 458
  ClientWidth = 851
  Color = clAppWorkSpace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  FormStyle = fsMDIForm
  OldCreateOrder = False
  Position = poScreenCenter
  OnDestroy = FormDestroy
  DesignSize = (
    851
    458)
  PixelsPerInch = 96
  TextHeight = 13
  object Image1: TImage
    Left = 384
    Top = 200
    Width = 32
    Height = 32
  end
  object BtMenus: TButton
    Left = 463
    Top = 79
    Width = 75
    Height = 25
    Caption = 'BtMenus'
    TabOrder = 0
  end
  object MenuLateral: TButton
    Left = 463
    Top = 8
    Width = 75
    Height = 25
    Caption = 'MenuLateral'
    TabOrder = 1
    OnClick = MenuLateralClick
  end
  object Memo1: TMemo
    Left = 544
    Top = 8
    Width = 304
    Height = 445
    Anchors = [akTop, akRight]
    TabOrder = 2
  end
  object Button1: TButton
    Left = 463
    Top = 39
    Width = 75
    Height = 25
    Caption = 'Free'
    TabOrder = 3
    OnClick = Button1Click
  end
end

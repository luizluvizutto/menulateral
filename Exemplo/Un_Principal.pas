unit Un_Principal;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls,

  Un_MenuLateral,
  Un_MenuLateralDef, Vcl.ExtCtrls;

type

  TGraphicAccess = class(TGraphic)
  end;

  TForm1 = class(TForm)
    BtMenus: TButton;
    MenuLateral: TButton;
    Memo1: TMemo;
    Button1: TButton;
    Image1: TImage;

    procedure MenuLateralClick(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure FormDestroy(Sender: TObject);

  private
    FMenuLateral: TmtMenuLateral;
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}

// *****************************************************************************
procedure TForm1.FormDestroy(Sender: TObject);
begin
   if FMenuLateral <> NIL then
      FMenuLateral.Free;
end;

procedure TForm1.MenuLateralClick(Sender: TObject);
var cPath: String;
begin
   if FMenuLateral = NIL then begin
      FMenuLateral := TmtMenuLateral.Create(Self);
      FMenuLateral.Log := Memo1.Lines;
      cPath := ExtractFilePath( Application.ExeName );
      FMenuLateral.PathImg := cPath + 'img\';
      FMenuLateral.Menus.Add('',           'MnProduto',       'Produtos',  NIL, 'produto.bmp');
      FMenuLateral.Menus.Add('MnProduto',  'MnProdSetor',     'Setor',     NIL, 'Picture.bmp');
      FMenuLateral.Menus.Add('MnProdSetor','MnProdSubSetor',  'SubSetor',  NIL, 'Picture.bmp');
      FMenuLateral.Menus.Add('',           'MnPessoa'   ,     'Pessoas',   NIL, 'Pessoa.bmp');
      FMenuLateral.Menus.Add('',           'MnNFe',           'Notas Fiscais', NIL, 'NF-e.bmp');
      FMenuLateral.Ativo := true;
   end;
end;
// *****************************************************************************
end.

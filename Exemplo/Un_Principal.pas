unit Un_Principal;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls,

  Un_MenuLateral,
  Un_MenuLateralDef,

  Vcl.ExtCtrls;

type

  TForm1 = class(TForm)
    BtMenus: TButton;
    MenuLateral: TButton;
    Memo1: TMemo;
    Button1: TButton;

    procedure FormDestroy(Sender: TObject);
    procedure FormCreate(Sender: TObject);

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
procedure TForm1.FormCreate(Sender: TObject);
var cPath: String;
begin
   FMenuLateral := TmtMenuLateral.Create(Self);
   // FMenuLateral.Log := Memo1.Lines;
   cPath := ExtractFilePath( Application.ExeName );
   FMenuLateral.PathImg := cPath + 'img\';
   FMenuLateral.Cor := $00F9E9DB;
   FMenuLateral.Menus.CorNivel[1] := $00F0CAA8;
   FMenuLateral.Menus.CorNivel[2] := $00E9AF7C;

   FMenuLateral.Menus.Add('',           'MnProduto',       'Produtos',  NIL, 'produto.bmp');
   FMenuLateral.Menus.Add('MnProduto',  'MnProdSetor',     'Setor',     NIL, 'Picture.bmp');
   FMenuLateral.Menus.Add('MnProduto',  'MnProdSubSetor',  'Sub-Setor',  NIL, 'Picture.bmp');

   FMenuLateral.Menus.Add('',           'MnPessoa'   ,     'Pessoas',   NIL, 'Pessoa.bmp');
   FMenuLateral.Menus.Add('',           'MnNFe',           'Notas Fiscais', NIL, 'NF-e.bmp');

   FMenuLateral.Menus.Add('',           'MnFinanceiro',    'Financeiro', NIL, 'Financas.bmp');
   FMenuLateral.Menus.Add('MnFinanceiro','MnFinanCPag',    'Contas a Pagar', NIL, 'CPagar.bmp');
   FMenuLateral.Menus.Add('MnFinanceiro','MnFinanCRec',    'Contas a Receber', NIL, 'CReceber.bmp');
   FMenuLateral.Ativo := true;
end;
// *****************************************************************************
procedure TForm1.FormDestroy(Sender: TObject);
begin
   if FMenuLateral <> NIL then
      FMenuLateral.Free;
end;
// *****************************************************************************
end.

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
begin
   FMenuLateral := TmtMenuLateral.Create(Self);
   FMenuLateral.PathImg := ExtractFilePath( Application.ExeName ) + 'img\';
   FMenuLateral.Cor := $00F9E9DB;
   FMenuLateral.Menus.CorNivel[1]  := $00E3E3FF;
   FMenuLateral.Menus.CorNivel[2]  := $00DBFFED;
   {
   FMenuLateral.Menus.CorNivel[3]  := $00F0CAA8;
   FMenuLateral.Menus.CorNivel[4]  := $00E9AF7C;
   FMenuLateral.Menus.CorNivel[5]  := $00F0CAA8;
   FMenuLateral.Menus.CorNivel[6]  := $00E9AF7C;
   FMenuLateral.Menus.CorNivel[7]  := $00E9AF7C;
   FMenuLateral.Menus.CorNivel[8]  := $00E9AF7C;
   FMenuLateral.Menus.CorNivel[9]  := $00E9AF7C;
   FMenuLateral.Menus.CorNivel[10] := $00E9AF7C;
   }

   FMenuLateral.Menus.Add('',              'MnProduto',       'Produtos',         NIL, 'produto.bmp');
     FMenuLateral.Menus.Add('MnProduto',   'MnProdSetor',     'Setor',            NIL, 'Picture.bmp');
     FMenuLateral.Menus.Add('MnProdSetor', 'MnProdSubSetor',  'Sub-Setor',        NIL, 'Picture.bmp');

   FMenuLateral.Menus.Add('',              'MnPessoa',        'Pessoas',          NIL, 'Pessoa.bmp');
   FMenuLateral.Menus.Add('',              'MnNFe',           'Notas Fiscais',    NIL, 'NF-e.bmp');

   FMenuLateral.Menus.Add('',              'MnFinanceiro',    'Financeiro',       NIL, 'Financas.bmp');
     FMenuLateral.Menus.Add('MnFinanceiro','MnFinanCPag',     'Contas a Pagar',   NIL, 'CPagar.bmp');
     FMenuLateral.Menus.Add('MnFinanceiro','MnFinanCRec',     'Contas a Receber', NIL, 'CReceber.bmp');


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

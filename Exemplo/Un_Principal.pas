unit Un_Principal;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls,

  Un_MenuLateral,
  Un_MenuLateralDef,

  Un_Configura,

  Vcl.ExtCtrls;

type

  TsiConfMenuLateral = class( TComponent )
  private
     FMenus: TmtMenus;
     FPainelEscolha: TPanel;

     procedure Clique( Sender: TObject );
     procedure Limpar;
     procedure AtribuirEvento;
  public
     property Menus: TmtMenus read FMenus write FMenus;
     property PainelEscolha: TPanel read FPainelEscolha write FPainelEscolha;

     procedure Montar;

     constructor Create(AOwner: TComponent); override;
     destructor Destroy; override;

  end;

  TForm1 = class(TForm)

    procedure FormDestroy(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure Button1Click(Sender: TObject);

  private
    FMenuLateral: TmtMenuLateral;

    procedure OK( Sender: TObject );
    procedure Configurar( Sender: TObject );
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}

// *****************************************************************************
procedure TForm1.Button1Click(Sender: TObject);
begin
   Configurar(NIL);
end;

procedure TForm1.Configurar(Sender: TObject);
var x: TForm2;
begin
   x := TForm2.Create(Self);
   try
     x.Menus := FMenuLateral.Menus;
     x.ShowModal;
   finally
     x.Free;
   end;
end;
// *****************************************************************************
procedure TForm1.FormCreate(Sender: TObject);
begin

   FMenuLateral := TmtMenuLateral.Create(Self);
   FMenuLateral.PathImg := ExtractFilePath( Application.ExeName ) + 'img\';

   // FMenuLateral.Expandir := true;
   // FMenuLateral.PathImg := 'C:\DesenvolWin\EstoqueWinXE\ArquivoRes\BitMaps\';
   FMenuLateral.Cor := $00F9E9DB;
   FMenuLateral.ExpandirNoClique := true;
   // FMenuLateral.Log := Memo1.Lines;
   FMenuLateral.Menus.CorNivel[1]  := $00E3E3FF;
   FMenuLateral.Menus.CorNivel[2]  := $00DBFFED;

   FMenuLateral.ExpandirNoClique := true;

   FMenuLateral.Menus.Add('',              'MnProduto',       'Produtos',         OK, 'produto.bmp');
     FMenuLateral.Menus.Add('MnProduto',   'MnProdPromocao',  'Promoções',        OK, 'Raio.bmp');
     FMenuLateral.Menus.Add('MnProduto',   'MnProdTrocar',    'Troca Vinculada',  OK, 'Trocar.bmp');
     FMenuLateral.Menus.Add('MnProduto',   'MnProdReajPreco', 'Reajustar Preço',  OK, 'Financas.bmp');
     FMenuLateral.Menus.Add('MnProduto',   'MnProdTabAux',    'Tabelas Auxiliares', NIL, '');
        FMenuLateral.Menus.Add('MnProdTabAux', 'MnProdSetor',     'Setor',            OK, 'Picture.bmp');
        FMenuLateral.Menus.Add('MnProdTabAux', 'MnProdSubSetor',  'Sub-Setor',        OK, 'Picture.bmp');

   FMenuLateral.Menus.Add('',              'MnPessoa',        'Pessoas',          OK, 'Pessoa.bmp');
   FMenuLateral.Menus.Add('',              'MnNFe',           'Notas Fiscais',    NIL, 'NF-e.bmp');

   FMenuLateral.Menus.Add('',              'MnECommerce',         'e-Commerce',       NIL, 'e-Commerce.bmp');
     FMenuLateral.Menus.Add('MnECommerce', 'MnECommMercadoLivre', 'MercadoLivre',     OK, 'MercadoLivre.bmp');
     FMenuLateral.Menus.Add('MnECommerce', 'MnECommWordPress',    'WordPress',        OK, 'WordPress.bmp');

   FMenuLateral.Menus.Add('',              'MnFinanceiro',    'Financeiro',       NIL, 'Moedas.bmp');
     FMenuLateral.Menus.Add('MnFinanceiro','MnFinanBol',      'Boletos',          OK, 'barCode.bmp');
     FMenuLateral.Menus.Add('MnFinanceiro','MnFinanCPag',     'Contas a Pagar',   OK, 'CPagar.bmp');
     FMenuLateral.Menus.Add('MnFinanceiro','MnFinanCRec',     'Contas a Receber', OK, 'CReceber.bmp');

   FMenuLateral.Menus.Add('',              'MnCompras',       'Compras',           OK, 'Compras.bmp');
   FMenuLateral.Menus.Add('',              'MOrdemServico',   'Ordem de Serviço',  OK, 'OS.bmp');
   FMenuLateral.Menus.Add('',              'MnAcesso',        'Acessos',           OK, 'Acessos.bmp');

   FMenuLateral.Menus.Add('',              'MnConfiguracao',  'Configuração Menu', Configurar, 'OS.bmp');

   FMenuLateral.Ativo := true;
end;
// *****************************************************************************
procedure TForm1.FormDestroy(Sender: TObject);
begin
   if FMenuLateral <> NIL then
      FMenuLateral.Free;

end;

procedure TForm1.OK(Sender: TObject);
begin
   ShowMessage( 'OK' );
end;

// *****************************************************************************
{ TsiConfMenuLateral }

procedure TsiConfMenuLateral.AtribuirEvento;
var i: Integer;
begin
   if FPainelEscolha <> NIL then
      for i := FPainelEscolha.ComponentCount-1 downto 0 do
         TCheckBox( FPainelEscolha.Components[i] ).OnClick := clique;
end;

procedure TsiConfMenuLateral.Clique(Sender: TObject);
var M: TmtMenu;

   procedure DesligarFilhos( _nome: String );
   var
     _i: Integer;
     _Chk: TCheckBox;
   begin
      for _i := 0 to FMenus.Count -1 do begin
         if FMenus.Menu[_i].Pai = _nome then begin
            _Chk := TCheckBox( FPainelEscolha.FindComponent( FMenus.Menu[_i].Nome ) );
            _Chk.Checked := false;
         end;
      end;
   end;

   procedure LigarPai( _nome: String );
   var
     _M: TmtMenu;
     _Chk: TCheckBox;
   begin
      _M := FMenus.Localizar(_nome);
      _Chk := TCheckBox( FPainelEscolha.FindComponent( _M.Nome ) );
      _Chk.Checked := true;
      if _M.Pai <> '' then begin
         LigarPai( _M.Pai );
      end;
   end;

begin
   M := FMenus.Localizar( TComponent( Sender ).Name );
   if M <> NIL then begin

      M.Visivel := not M.Visivel;

      if not M.Visivel then begin
         DesligarFilhos( M.Nome );
      end else begin
         LigarPai( M.Nome );
      end;
   end;
end;
// *****************************************************************************
constructor TsiConfMenuLateral.Create(AOwner: TComponent);
begin
   inherited;
   FMenus := TmtMenus.Create(Self);
end;
// *****************************************************************************
destructor TsiConfMenuLateral.Destroy;
begin
   FMenus.Free;
   inherited;
end;
// *****************************************************************************
procedure TsiConfMenuLateral.Limpar;
var i: Integer;
begin
   if FPainelEscolha <> NIL then begin
      for i:= FPainelEscolha.ComponentCount-1 downto 0 do
         FPainelEscolha.Components[i].Free;
   end;
end;
//
procedure TsiConfMenuLateral.Montar;
var
   Linha: Integer;
   chk: TCheckBox;

  procedure M( _nome: String; _l: Integer );
  var i: Integer;
  begin
     for i := 0 to FMenus.Count -1 do begin
        if FMenus.Menu[i].Pai = _nome then begin
           chk := TCheckBox.Create(FPainelEscolha);
           chk.Parent := FPainelEscolha;
           chk.top := (Linha);
           chk.Caption := FMenus.Menu[i].Caption;
           chk.Name := FMenus.Menu[i].Nome;
           chk.Left := _l + 20;

           chk.Checked := FMenus.Menu[i].Visivel;

           Linha := Linha + 25;

           M( FMenus.Menu[i].Nome, chk.Left );
        end;
     end;
  end;

begin

   Limpar;
   Linha := 1;
   M( '', 1 );

   AtribuirEvento;

end;

end.

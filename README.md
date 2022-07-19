# Simples Menu Lateral criado com panel e speedbutton

```  
Uses
  Un_MenuLateral,
  Un_MenuLateralDef;
...
var
  FMenuLateral: TmtMenuLateral;
...
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
```

###### Doação colaboração chave pix: 2d405f0d-ea0e-4152-bc7c-6f3a7e476b92

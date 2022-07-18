# MenuLateral
 Menu Lateral com SpeedButton
  
  uses
  Un_MenuLateral,
  Un_MenuLateralDef;

var
  FMenuLateral: TmtMenuLateral;
  
  ...
  
  ### Create
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


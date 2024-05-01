import 'package:flutter/material.dart';
import 'package:flutter_masked_text2/flutter_masked_text2.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import '../admob/keys.dart';
import '../banco_dados/bd.dart';
import '../lote_excel/lote_excel.dart';
import '../model/cnpj_model.dart';
import 'clientes_screen.dart';
import 'lote_screen.dart';

class ExcelImportScreen extends StatefulWidget {
  @override
  _ExcelImportScreenState createState() => _ExcelImportScreenState();
}

class _ExcelImportScreenState extends State<ExcelImportScreen> {
  bool _isInsert = false;
  InterstitialAd? _interstitialAd;

  // Criando o controller com a máscara de CNPJ
  var _cnpjController = MaskedTextController(mask: '00.000.000/0000-00');

  @override
  void initState() {
    myBanner.load();
    createInterstitialAd();
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text(
          'Consultar Cnpj na Receita', style: TextStyle(color: Colors.amber),),
      ),
      body: SingleChildScrollView(
        child: Column(
          // mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _cnpjController,
                      keyboardType: TextInputType.number,
                      cursorColor: Colors.black,
                      decoration: const InputDecoration(
                        hintText: 'Digite um CNPJ',
                        border: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.amber, // Cor padrão da borda
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.amber, // Cor da borda habilitada
                            width: 2.0,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.amber, // Cor da borda em foco
                            width: 2.0,
                          ),
                        ),
                      ),

                      validator: (value) {
                        // Remove os caracteres não numéricos para validar
                        String digits = value!.replaceAll(RegExp(r'\D'), '');
                        if (digits.length != 14) {
                          return 'O CNPJ precisa ter 14 números';
                        }
                        return null; // Retorna null se o valor passar na validação
                      },
                    ),
                  ),
                  const SizedBox(width: 8),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.amber,
                      backgroundColor: Colors
                          .black, // Cor do texto e ícones do botão
                    ),
                    onPressed: _isInsert
                        ? null
                        : () async {
                      setState(() {
                        _isInsert = true;
                      });
                      // Verifica se o campo do CNPJ é válido
                      if (_cnpjController.text.length == 18) {
                        FocusManager.instance.primaryFocus?.unfocus();
                        String cnpj = _cnpjController.text.replaceAll(".", "")
                            .replaceAll("/", "")
                            .replaceAll("-", "");
                        if (validarCNPJ(cnpj)) {
                          await DatabaseHelper.instance.insertCnpj(
                              Cliente(cnpj: cnpj));
                          await fetchInfoCnpj(context, cnpj);
                          _cnpjController.text = "";
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content:
                                Text('CNPJ Inválido'),
                                duration: Duration(seconds: 4),
                              ));
                        }
                        setState(() {
                          _isInsert = false;
                        });
                      } else {
                        setState(() {
                          _isInsert = false;
                        });
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text(
                              'CNPJ inválido. Insira 14 números.')),
                        );
                      }
                    },
                    child: Text(_isInsert
                        ? 'Inserindo'
                        : 'Buscar'),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.amber,
                backgroundColor: Colors.black, // Cor do texto e ícones do botão
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => loteScreen()),
                );
              },
              child: const Column(
                children: [
                  Text('Inserir CNPJs em Lote'),
                  Text('(Arquivo no formato Excel)',
                      style: TextStyle(fontSize: 8)),
                ],
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.amber,
                backgroundColor: Colors.black, // Cor do texto e ícones do botão
              ),
              onPressed: () {
                showInterstitialAd();
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ClientesInfoScreen()),
                );
              },
              child: const Text('Ver Todos os CNPJ salvos'),
            ),
            const SizedBox(height: 110),
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                color: Colors.transparent,
                width: 300,
                height: 250,
                child: AdWidget(
                  ad: myBanner,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  bool validarCNPJ(String cnpj) {
    // Remove caracteres não numéricos
    var numeros = cnpj.replaceAll(RegExp(r'\D'), '');

    if (numeros.length != 14) return false;

    // Lista com os pesos para calcular o primeiro dígito verificador
    var pesos1 = [5, 4, 3, 2, 9, 8, 7, 6, 5, 4, 3, 2];

    // Lista com os pesos para calcular o segundo dígito verificador
    var pesos2 = [6, 5, 4, 3, 2, 9, 8, 7, 6, 5, 4, 3, 2];

    // Calcula o primeiro dígito verificador
    var soma1 = 0;
    for (var i = 0; i < 12; i++) {
      soma1 += int.parse(numeros[i]) * pesos1[i];
    }
    var resto1 = soma1 % 11;
    var dv1 = resto1 < 2 ? 0 : 11 - resto1;

    if (int.parse(numeros[12]) != dv1) return false;

    // Calcula o segundo dígito verificador
    var soma2 = 0;
    for (var i = 0; i < 13; i++) {
      soma2 += int.parse(numeros[i]) * pesos2[i];
    }
    var resto2 = soma2 % 11;
    var dv2 = resto2 < 2 ? 0 : 11 - resto2;

    return int.parse(numeros[13]) == dv2;
  }

  final BannerAd myBanner = BannerAd(
    adUnitId: Keys().banner,
    size: AdSize.mediumRectangle,
    request: const AdRequest(),
    listener: BannerAdListener(
      onAdLoaded: (Ad ad) {
        print('Anúncio carregado.');
      },
      onAdFailedToLoad: (Ad ad, LoadAdError error) {
        print('Anúncio falhou ao carregar: $error');
      },
      // Outros callbacks conforme necessário...
    ),
  );

  void createInterstitialAd() {
    InterstitialAd.load(
        adUnitId: Keys().interstitial,
        request: const AdRequest(),
        adLoadCallback: InterstitialAdLoadCallback(
          onAdLoaded: (InterstitialAd ad) {
            // Mantém uma referência ao anúncio para que possa ser mostrado mais tarde.
            this._interstitialAd = ad;
            print("Anúncio intersticial carregado");
            // Defina aqui o callback para quando o anúncio for dispensado
            _interstitialAd?.fullScreenContentCallback = FullScreenContentCallback(
              onAdDismissedFullScreenContent: (InterstitialAd ad) {
                ad.dispose();
                // Carregue um novo anúncio para o próximo uso.
                createInterstitialAd();
              },
              onAdFailedToShowFullScreenContent: (InterstitialAd ad, AdError error) {
                print("Falha ao exibir o anúncio intersticial: $error");
                ad.dispose();
                // Você pode optar por tentar carregar um novo anúncio aqui também.
              },
            );
          },
          onAdFailedToLoad: (LoadAdError error) {
            print("Falha ao carregar o anúncio intersticial: $error");
            // Tratar falha no carregamento, pode-se tentar recarregar aqui também
          },
        ));
  }

  void showInterstitialAd() {
    if (_interstitialAd == null) {
      print("Anúncio intersticial não está pronto ainda.");
      createInterstitialAd(); // Tenta carregar um novo anúncio se o atual for nulo
      return;
    }
    _interstitialAd?.fullScreenContentCallback = FullScreenContentCallback(
      onAdDismissedFullScreenContent: (InterstitialAd ad) {
        ad.dispose();
      },
      onAdFailedToShowFullScreenContent: (InterstitialAd ad, AdError error) {
        ad.dispose();
      },
    );
    _interstitialAd?.show();
    _interstitialAd = null;
  }
}
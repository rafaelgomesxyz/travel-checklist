import 'package:travel_checklist/enums.dart';

class TripBuilder {
  TripBuilder._privateConstructor(); // Singleton
  static final TripBuilder instance = TripBuilder._privateConstructor();

  Map<String, List<String>> getPredefinedChecklists(Template template) {
    Map<String, List<String>> common = {
      'Acessórios': [
        'Bolsa',
        'Câmera fotográfica',
        'Carregador de celular',
        'Carregador portátil',
        'Cartões de crédito',
        'Carteira',
        'Carteira de habilitação',
        'Dinheiro',
        'Documentos pessoais',
        'Fones de ouvido',
        'Lanches',
        'Óculos escuros',
        'Relógio',
        'Remédios',
        'RG',
      ],
      'Higiene Pessoal': [
        'Absorvente',
        'Algodão',
        'Condicionador',
        'Cotonetes',
        'Creme Dental',
        'Creme hidratante corporal',
        'Creme hidratante facial',
        'Desodorante',
        'Escova de Cabelo',
        'Escova de Dentes',
        'Fio dental',
        'Kit de unhas',
        'Lenços umedecidos',
        'Perfume',
        'Pinça',
        'Protetor Solar',
        'Shampoo',
      ],
      'Vestuário': [
        'Anéis',
        'Blusas',
        'Calças'
        'Camisas',
        'Chinelos',
        'Cintos',
        'Colares',
        'Meias',
        'Pulseiras',
        'Saias',
        'Tênis',
        'Sandálias',
        'Suspensórios',
        'Roupa íntima',
      ],
    };
    switch (template) {
      case Template.Praia:
        return {
          'Acessórios': [
            ...common['Acessórios'],
            'Bebidas',
            'Bóia',
            'Bola de futebol',
            'Caixa térmica',
            'Chapéu',
            'Guarda Sol',
          ],
          'Higiene Pessoal': [
            ...common['Higiene Pessoal'],
            'Bronzeador',
            'Pós-sol',
            'Protetor Solar',
            'Protetor labial',
            'Toalha de banho',
          ],
          'Vestuário': [
            ...common['Vestuário'],
            'Roupa de banho',
            'Short',
            'Camiseta regata',
            'Saída de praia',
          ],
        };
      case Template.Campo:
        return {
          'Acessórios': [
            ...common['Acessórios'],
            'Abridor de latas',
            'Barraca',
            'Canivete',
            'Capa de chuva',    
            'Coador de café',
            'Cobertores',
            'Colchão inflável',
            'Corda',
            'Garrafa de água',
            'Lanterna',
            'Mochila',
            'Saco de dormir',
            'Sacos de lixo',
            'Talheres',
            'Travesseiro',
          ],
          'Higiene Pessoal': [
            ...common['Higiene Pessoal'],
            'Antisséptico',
            'Repelente de insetos',
            'Sabonete',
            'Toalha de banho',
            'Toalha de rosto',  
          ],
          'Vestuário': [
            ...common['Vestuário'],
            'Bota impermeável',
            'Casacos',
            'Camisa de manga longa',
            'Sapatos fechados',
          ],
        };
      case Template.Cidade:
        return {
          'Acessórios': [
            ...common['Acessórios'],
            'Adaptador de tomada',
            'Passaporte',
            'Porta Dolar',
            'Reservas impressas',
            'Vistos',
            'Voucher de passeios',
            'Voucher de shows',
          ],
          'Higiene Pessoal': [
            ...common['Higiene Pessoal'],
            'Barbeador',
            'Chapinha',
            'Demaquilante',
            'Maquiagem',
            'Secador de cabelos',
          ],
          'Vestuário': [
            ...common['Vestuário'],
            'Boné',
            'Cachecol',
            'Gravatas',
            'Roupa social',
            'Paletó',
            'Casaco',
            'Luvas',
            'Vestido',
          ],
        };
      case Template.Outro:
        return null;
    }
    return null;
  }
}

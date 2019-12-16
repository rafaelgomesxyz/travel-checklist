import 'package:travel_checklist/enums.dart';

class TripBuilder {
  TripBuilder._privateConstructor(); // Singleton
  static final TripBuilder instance = TripBuilder._privateConstructor();

  Map<String, List<String>> getPredefinedChecklists(Template template) {
    Map<String, List<String>> common = {
      '01. Etapas da Viagem': [
        '01. Passaporte',
        '02. Visto',
        '03. Passagem',
        '04. Check-in',
      ],
      '02. Higiene Pessoal': [
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
      '03. Vestuário': [
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
      '04. Acessórios': [
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
    };
    switch (template) {
      case Template.Praia:
        return {
          '01. Etapas da Viagem': [
            ...common['01. Etapas da Viagem'],
          ],
          '02. Higiene Pessoal': [
            ...common['02. Higiene Pessoal'],
            'Bronzeador',
            'Pós-sol',
            'Protetor Solar',
            'Protetor labial',
            'Toalha de banho',
          ],
          '03. Vestuário': [
            ...common['03. Vestuário'],
            'Roupa de banho',
            'Short',
            'Camiseta regata',
            'Saída de praia',
          ],
          '04. Acessórios': [
            ...common['04. Acessórios'],
            'Bebidas',
            'Bóia',
            'Bola de futebol',
            'Caixa térmica',
            'Chapéu',
            'Guarda Sol',
          ],
        };
      case Template.Campo:
        return {
          '01. Etapas da Viagem': [
            ...common['01. Etapas da Viagem'],
          ],
          '02. Higiene Pessoal': [
            ...common['02. Higiene Pessoal'],
            'Antisséptico',
            'Repelente de insetos',
            'Sabonete',
            'Toalha de banho',
            'Toalha de rosto',  
          ],
          '03. Vestuário': [
            ...common['03. Vestuário'],
            'Bota impermeável',
            'Casacos',
            'Camisa de manga longa',
            'Sapatos fechados',
          ],
          '04. Acessórios': [
            ...common['04. Acessórios'],
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
        };
      case Template.Cidade:
        return {
          '01. Etapas da Viagem': [
            ...common['01. Etapas da Viagem'],
          ],
          '02. Higiene Pessoal': [
            ...common['02. Higiene Pessoal'],
            'Barbeador',
            'Chapinha',
            'Demaquilante',
            'Maquiagem',
            'Secador de cabelos',
          ],
          '03. Vestuário': [
            ...common['03. Vestuário'],
            'Boné',
            'Cachecol',
            'Gravatas',
            'Roupa social',
            'Paletó',
            'Casaco',
            'Luvas',
            'Vestido',
          ],
          '04. Acessórios': [
            ...common['04. Acessórios'],
            'Adaptador de tomada',
            'Passaporte',
            'Porta Dolar',
            'Reservas impressas',
            'Vistos',
            'Voucher de passeios',
            'Voucher de shows',
          ],
        };
      case Template.Outro:
        return null;
    }
    return null;
  }
}

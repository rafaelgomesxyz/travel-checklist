import 'package:travel_checklist/enums.dart';

class TripBuilder {
  TripBuilder._privateConstructor(); // Singleton
  static final TripBuilder instance = TripBuilder._privateConstructor();

  Map<String, List<String>> getPredefinedChecklists(Template template) {
    Map<String, List<String>> common = {
      'Acessórios': [
        'Carteira',
        'Bolsa',
        'Câmera fotográfica',
        'Carregador de celular',
        'Carregador portátil',
        'Documentos pessoais',
        'Remédios',
      ],
      'Higiene Pessoal': [
        'Condicionador',
        'Cotonetes',
        'Creme Dental',
        'Desodorante',
        'Escova de Cabelo',
        'Escova de Dentes',
        'Fio dental',
        'Perfume',
        'Protetor Solar',
        'Shampoo',
      ],
      'Vestuário': [
        'Blusas',
        'Calças'
        'Camisas',
        'Chinelos',
        'Meias',
        'Sapatos',
        'Roupa íntima',
      ],
    };
    switch (template) {
      case Template.Praia:
        return {
          'Acessórios': [
            ...common['Acessórios'],
            'Bóia',
            'Bola de futebol',
            'Chapéu',
            'Guarda Sol',
            'Óculos escuros',
          ],
          'Higiene Pessoal': [
            ...common['Higiene Pessoal'],
            'Bronzeador',
            'Protetor Solar',
            'Toalha de banho',
          ],
          'Vestuário': [
            ...common['Vestuário'],
            'Roupa de banho',
            'Short',
            'Camiseta regata',
            'Protetor labial',
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
            'Item3',
            'Item4',
          ],
          'Higiene Pessoal': [
            ...common['Higiene Pessoal'],
            'Item3',
            'Item4',
          ],
          'Vestuário': [
            ...common['Vestuário'],
            'Item3',
            'Item4',
          ],
        };
      case Template.Outro:
        return null;
    }
    return null;
  }
}

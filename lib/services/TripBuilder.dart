import 'package:travel_checklist/enums.dart';

class TripBuilder {
  TripBuilder._privateConstructor(); // Singleton
  static final TripBuilder instance = TripBuilder._privateConstructor();

  Map<String, List<String>> getPredefinedChecklists(Template template) {
    Map<String, List<String>> common = {
      'Acessórios': [
        'Item1',
        'Item2',
      ],
      'Higiene Pessoal': [
        'Item1',
        'Item2',
      ],
      'Vestuário': [
        'Item1',
        'Item2',
      ],
    };
    switch (template) {
      case Template.Praia:
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
      case Template.Campo:
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
import 'package:service_app/models/service.dart';

final services = <Service>[
  new Service(
    id: 1,
    customer: 'Иван',
    customerAddress:  'Пермь, Ленина 10',
    phone: '880020030023',
    comment: 'Какой то коментарий клиента, клиент прсоил не беспкоить раньше 12 часов дня',
    brandId: 'Стеклодом',
    number: 'Сервис Адм_0003232 ывыоыовы ыввыоыц2оовы'
  ),
  new Service(
    id: 2,
    customer: 'Гашков Петр Васильевич',
    customerAddress: 'Пермь, Мира 22',
    phone: '880030030023',
    comment: 'Какой то коментарий клиента',
    brandId: 'Погода в доме',
      number: 'Сервис Адм_0004327 выывооыв ыввыыовыо ывыоыво'
  ),
];
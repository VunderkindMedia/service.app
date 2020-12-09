import 'package:service_app/models/service-status.dart';
import 'package:service_app/models/service.dart';

final services = <Service>[
  new Service(
    id: 1,
    customer: 'Ивнов Иван Ивнович',
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
  new Service(
    id: 3,
    customer: 'Патанина Вера Ивновна',
    customerAddress: 'Пермь, Мира 22',
    phone: '880030030023',
    comment: 'Какой то коментарий клиента',
    brandId: 'Погода в доме',
    number: 'Сервис Адм_0004327 выывооыв ыввыыовыо ывыоыво'
  ),
  new Service(
    id: 4,
    customer: 'Чубайс Виктор Петрович',
    customerAddress: 'Пермь, Мира 22',
    phone: '880030030023',
    comment: 'Какой то коментарий клиента',
    brandId: 'Погода в доме',
    number: 'Сервис Адм_0004327 выывооыв ыввыыовыо ывыоыво',
    status: ServiceStatus.Finished.toString()
  ),
  new Service(
    id: 5,
    customer: 'Шилова Алена Васильевна',
    customerAddress: 'Пермь, Мира 22',
    phone: '880030030023',
    comment: 'Какой то коментарий клиента',
    brandId: 'Погода в доме',
    number: 'Сервис Адм_0004327 выывооыв ыввыыовыо ывыоыво',
    status: ServiceStatus.Finished.toString()
  ),
  new Service(
    id: 6,
    customer: 'Тихонов Мирон Александрвич',
    customerAddress: 'Пермь, Мира 22',
    phone: '880030030023',
    comment: 'Какой то коментарий клиента',
    brandId: 'Погода в доме',
    number: 'Сервис Адм_0004327 выывооыв ыввыыовыо ывыоыво',
    status: ServiceStatus.Finished.toString()
  ),
  new Service(
    id: 7,
    customer: 'Кузнецов Олег Евгенич',
    customerAddress: 'Пермь, Мира 22',
    phone: '880030030023',
    comment: 'Какой то коментарий клиента',
    brandId: 'Погода в доме',
    number: 'Сервис Адм_0004327 выывооыв ыввыыовыо ывыоыво'
  ),
  new Service(
    id: 8,
    customer: 'Федоров Михаил Попович',
    customerAddress: 'Пермь, Мира 22',
    phone: '880030030023',
    comment: 'Какой то коментарий клиента',
    brandId: 'Погода в доме',
    number: 'Сервис Адм_0004327 выывооыв ыввыыовыо ывыоыво',
    status: ServiceStatus.Finished.toString()
  ),
  new Service(
    id: 9,
    customer: 'Нестеров Сергей Михайлович',
    customerAddress: 'Пермь, Мира 22',
    phone: '880030030023',
    comment: 'Какой то коментарий клиента',
    brandId: 'Погода в доме',
    number: 'Сервис Адм_0004327 выывооыв ыввыыовыо ывыоыво'
  ),
  new Service(
    id: 10,
    customer: 'Королев Александр Олегович',
    customerAddress: 'Пермь, Мира 22',
    phone: '880030030023',
    comment: 'Какой то коментарий клиента',
    brandId: 'Погода в доме',
    number: 'Сервис Адм_0004327 выывооыв ыввыыовыо ывыоыво',
    status: ServiceStatus.Finished.toString()
  ),
];
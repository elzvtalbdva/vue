import 'package:flutter/material.dart';
import '../models/product.dart';

/// Прямые ссылки на товары на русские сайты мебели (Hoff, Лига диванов, BMS, Мартин, Оливер, Divan.ru, MebelOk).
/// Включает только товары с реальными фото.

final List<Product> products = [
  // === HOFF PRODUCTS (4 items with real photos) ===
  Product(
    id: 'norvich-chair',
    name: 'Кресло для отдыха SCANDICA Норвич',
    category: 'Кресло',
    color: const Color(0xFFA35A47), // терракот #a35a47
    shop: 'Hoff',
    spec: '80×89×85 см · велюр терракот · ножки массив дерева',
    price: 15998,
    url: 'https://hoff.ru/catalog/gostinaya/kresla/kreslo_dlya_otdykha_norvich_id9720459/?articul=80600858',
    photos: const [
      ProductPhoto('assets/products/креслокоралл.png', view: ProductView.front),
      ProductPhoto('assets/products/креслокораллбок.png', view: ProductView.side),
      ProductPhoto('assets/products/креслокораллназад.png', view: ProductView.back),
      ProductPhoto('assets/products/креслокораллблизко.png', view: ProductView.closeup),
    ],
    sections: const [
      ProductSection('Габариты и посадка', [
        'Ш×В×Г: 80×89×85 см',
        'Посадочное место: 55×63 см',
        'Высота сиденья: 42 см',
        'Высота ножек: 18 см',
      ]),
      ProductSection('Конструкция', [
        'Макс. нагрузка: 100 кг',
        'Вес в упаковке: 27 кг',
        'Без бельевого ящика',
        'Чехол несъёмный',
      ]),
      ProductSection('Материалы', [
        'Обивка: велюр с водоотталкивающей пропиткой',
        'Стойкость: 25 000 циклов (Мартендейл)',
        'Каркас и ножки: массив дерева',
        'Основа сиденья: ЛДСП, наполнитель: эл. ППУ',
      ]),
    ],
  ),
  Product(
    id: 'trick-chandelier',
    name: 'Люстра подвесная FAVOURITE Trick',
    category: 'Свет',
    color: const Color(0xFFF3F3F3), // дымчато-белый #F3F3F3
    shop: 'Hoff',
    spec: '80×57×80 см · металл черный/белый · 6×E14',
    price: 20599,
    url: 'https://hoff.ru/catalog/tovary_dlya_doma/osveschenie/lustry_i_potolochnye_svetilniki/podvesnye_svetilniki/lyustra_podvesnaya_trick_id8638029/?articul=80526348',
    photos: const [
      ProductPhoto('assets/products/люстра1.png', view: ProductView.front),
      ProductPhoto('assets/products/люстра2.png', view: ProductView.side),
      ProductPhoto('assets/products/люстра3.png', view: ProductView.back),
      ProductPhoto('assets/products/люстраблизко.png', view: ProductView.closeup),
    ],
    sections: const [
      ProductSection('Габариты и монтаж', [
        'Размеры: 80×57×80 см',
        'Регулируемая высота: до 152 см',
        'Вес: 4,8 кг (в упаковке 5 кг)',
        'Крепление: на монтажную планку',
      ]),
      ProductSection('Освещение', [
        'Площадь освещения: до 12 м²',
        '6 ламп с цоколем E14',
        'Макс. мощность: 40 Вт каждая (всего 240 Вт)',
        'Лампы приобретаются отдельно',
      ]),
      ProductSection('Материалы и особенности', [
        'Арматура и плафоны: металл',
        'Цвет: чёрный каркас + белые плафоны',
        'Защита: IP20 (без влагозащиты)',
        'Нет пульта, выключателя на корпусе, умного управления',
        'Производство: Китай, гарантия 36 мес., срок службы 15 лет',
      ]),
    ],
  ),
  Product(
    id: 'slim-sofa',
    name: 'Угловой диван-кровать Слим',
    category: 'Диван',
    color: const Color(0xFFB8B0AA), // бежевый #b8b0aa
    shop: 'Hoff',
    spec: '206×91×153 см · велюр бежевый · механизм дельфин',
    price: 29999,
    url: 'https://hoff.ru/catalog/gostinaya/divany/uglovye/uglovoy_divan_krovat_slim_id9558189/?articul=80593875',
    photos: const [
      ProductPhoto('assets/products/диваннорм.png', view: ProductView.front),
      ProductPhoto('assets/products/дивансбоку.png', view: ProductView.side),
      ProductPhoto('assets/products/диванназад.png', view: ProductView.back),
      ProductPhoto('assets/products/диванблизко.png', view: ProductView.closeup),
    ],
    sections: const [
      ProductSection('Габариты и спальное место', [
        'Общие размеры: 206×91×153 см',
        'Спальное место: 142×195 см',
        'Глубина сиденья: 53 см (75 см без подушек)',
        'Высота сиденья: 45 см',
      ]),
      ProductSection('Трансформация и хранение', [
        'Механизм: «Дельфин»',
        'Универсальный угол (левая/правая сборка)',
        'Бельевой ящик: 145×23×61 см',
      ]),
      ProductSection('Материалы и комплектация', [
        'Обивка: велюр бежевый, 60 000 циклов',
        'Каркас: ЛДСП, основа: пружина «змейка»',
        'Наполнитель: ППУ, ножки: пластик черные (5,5 см)',
        'В комплекте: 3 приспинные + 2 декоративные подушки',
        'Нагрузка: 120 кг (спальное), 90 кг (посадочное)',
        'Вес: 99 кг (3 коробки)',
        'Производство: Россия, гарантия 18 мес., срок 5 лет',
      ]),
    ],
  ),
  Product(
    id: 'ludwig-chair',
    name: 'Кресло Людвиг',
    category: 'Кресло',
    color: const Color(0xFF4A232B), // темно-вишневый #4A232B
    shop: 'Hoff',
    spec: '74×91×90 см · велюр темно-вишневый · кант экокожа',
    price: 13598,
    url: 'https://hoff.ru/catalog/gostinaya/kresla/kreslo_lyudvig_id8102876/?articul=80443608',
    photos: const [
      ProductPhoto('assets/products/креслобургунди1.png', view: ProductView.front),
      ProductPhoto('assets/products/креслобургунди2.png', view: ProductView.side),
      ProductPhoto('assets/products/креслобургунди3.png', view: ProductView.back),
      ProductPhoto('assets/products/креслобургундиблизко.png', view: ProductView.closeup),
    ],
    sections: const [
      ProductSection('Габариты и посадка', [
        'Общие размеры: 74×91×90 см',
        'Сиденье: 50×48 см (59 см без подушки)',
        'Высота сиденья: 40 см, высота спинки: 51 см',
      ]),
      ProductSection('Конструкция и комплектация', [
        'Нераскладное, без ящика для белья',
        'В комплекте: поясничная подушка 30×53 см (чехол несъёмный)',
        'Макс. нагрузка на сиденье: 90 кг',
        'Вес с упаковкой: 22 кг (1 коробка)',
      ]),
      ProductSection('Материалы', [
        'Обивка: велюр темно-вишневый, 50 000 циклов',
        'Декоративный кант: коричневая искусственная кожа',
        'Каркас: ЛДСП, основа: пружина «змейка», наполнитель: ППУ',
        'Ножки: пластик коричневые (12 см)',
        'Производство: Россия, гарантия 18 мес., срок 5 лет',
      ]),
    ],
  ),

  // === ОРИГИНАЛЬНЫЕ ТОВАРЫ С РЕАЛЬНЫМИ ФОТО (7 items) ===
  Product(
    id: 'sofa-liga',
    name: 'Диван раскладной Лига диванов',
    category: 'Диван',
    color: const Color(0xFF60686D),
    shop: 'Лига диванов',
    spec: '227×90×141 см рогожка цвет амур 07 серый',
    price: 52990,
    url: 'https://nizhniy-novgorod.lemanapro.ru/product/divan-raskladnoy-liga-divanov-121139lspb-227x90x141-sm-rogozhka-cvet-amur-07-seryy-92390958/?utm_referrer=https%3A%2F%2Fnizhniy-novgorod.lemanapro.ru%2Fcatalogue%2Fdivany%2F',
    photos: const [
      ProductPhoto('assets/products/sofa-liga_front.png', view: ProductView.front),
      ProductPhoto('assets/products/sofa-liga_side.png', view: ProductView.side),
      ProductPhoto('assets/products/sofa-liga_back.png', view: ProductView.back),
      ProductPhoto('assets/products/sofa-liga_closeup.png', view: ProductView.closeup),
    ],
    sections: const [
      ProductSection('Размеры и спальное место', [
        'Габариты дивана: 227 x 141 x 90 см',
        'Размер спального места: 118 x 196 см',
        'Высота сиденья и спинки: 40 см',
        'Глубина сиденья: 69 см',
      ]),
      ProductSection('Конструкция и надежность', [
        'Тип: угловой раскладной диван с оттоманкой',
        'Раскладывается в спальное место',
        'Механизм: «Еврокнижка»',
      ]),
      ProductSection('Материалы', [
        'Обивка: рогожка, цвет «амур 07 серый» (#60686D)',
        'Каркас: металл + фанера',
        'Набивка: ППУ + пружинный блок',
      ]),
    ],
  ),
  Product(
    id: 'commode-mark2',
    name: 'Комод Марк-2 BMS',
    category: 'Комод',
    color: const Color(0xFF322019),
    shop: 'BMS',
    spec: '4 ящика · 2 распашных отделения · цвет венге',
    price: 35990,
    url: 'https://www.bestmebelshop.ru/catalog/komod/komod-mark-2-bms/',
    photos: const [
      ProductPhoto('assets/products/commode-mark2_front.png', view: ProductView.front),
      ProductPhoto('assets/products/commode-mark2_side.png', view: ProductView.side),
      ProductPhoto('assets/products/commode-mark2_back.png', view: ProductView.back),
      ProductPhoto('assets/products/commode-mark2_closeup.png', view: ProductView.closeup),
    ],
    sections: const [
      ProductSection('Основное', [
        'Стиль: элегантный современный',
        'Конструкция: комбинированная',
        'Столешница: широкая',
      ]),
      ProductSection('Наполнение', [
        '4 выдвижных ящика',
        '2 распашных отделения с полками',
      ]),
      ProductSection('Материалы', [
        'Цвет: венге (#322019)',
        'Фасады с текстурой тёмного дерева',
        'Металлические ручки',
      ]),
    ],
  ),
  Product(
    id: 'chair-neo',
    name: 'Стул Neo',
    category: 'Стул',
    color: const Color(0xFF8C7A80),
    shop: 'Lemanapro',
    spec: '44×84×53 см ножки металл/чёрный сиденье велюр пыльно-коричневый',
    price: 7490,
    url: 'https://nizhniy-novgorod.lemanapro.ru/product/stul-neo-44x84x53-sm-nozhki-metall-chernyy-sidene-velyur-cvet-pylno-korichnevyy-89385057/',
    photos: const [
      ProductPhoto('assets/products/chair-neo_front.png', view: ProductView.front),
      ProductPhoto('assets/products/chair-neo_side.png', view: ProductView.side),
      ProductPhoto('assets/products/chair-neo_back.png', view: ProductView.back),
      ProductPhoto('assets/products/chair-neo_closeup.png', view: ProductView.closeup),
    ],
    sections: const [
      ProductSection('Дизайн', [
        'Тип: кухонный стул',
        'Стиль: современный / классический',
        'Сиденье и спинка: мягкие, велюр',
      ]),
      ProductSection('Размеры', [
        'Габариты: 44 x 84 x 53 см',
        'Спинка с вертикальной простёжкой',
      ]),
      ProductSection('Материалы', [
        'Обивка: велюр, пыльно-коричневый (#8C7A80)',
        'Ножки: металл, чёрный',
      ]),
    ],
  ),
  Product(
    id: 'table-martin',
    name: 'Мартин СБ-3504 Стол',
    category: 'Стол',
    color: const Color(0xFFF5F5F5),
    shop: 'Мартин',
    spec: '117×59×74,6 см · цвет Белый',
    price: 18990,
    url: 'https://nn.stolplit.ru/internet-magazin/kupit/107120794-martin-sb-3504-stol/belyy/',
    photos: const [
      ProductPhoto('assets/products/table-martin_front.png', view: ProductView.front),
      ProductPhoto('assets/products/table-martin_side.png', view: ProductView.side),
      ProductPhoto('assets/products/table-martin_back.png', view: ProductView.back),
      ProductPhoto('assets/products/table-martin_closeup.png', view: ProductView.closeup),
    ],
    sections: const [
      ProductSection('Размеры', [
        'Ширина: 117 см',
        'Глубина: 59 см',
        'Высота: 74,6 см',
      ]),
      ProductSection('Конструкция', [
        'Столешница на двух боковых опорных панелях',
        'Передняя панель между опорами',
      ]),
      ProductSection('Материалы', [
        'Цвет: белый (#F5F5F5)',
        'Поверхность с мягкой фактурой',
      ]),
    ],
  ),
  Product(
    id: 'cabinet-oliver',
    name: 'Оливер стол угловой 1 дв',
    category: 'Кухня',
    color: const Color(0xFF7D8878),
    shop: 'Оливер',
    spec: 'Угловой кухонный модуль · 1 дверца · фасад цвета шалфей',
    price: 15990,
    url: 'https://nn.stolplit.ru/internet-magazin/kupit/113657335-oliver-stol-uglovoy-1-dv-100kh86-sm/',
    photos: const [
      ProductPhoto('assets/products/cabinet-oliver_front.png', view: ProductView.front),
      ProductPhoto('assets/products/cabinet-oliver_side.png', view: ProductView.side),
      ProductPhoto('assets/products/cabinet-oliver_back.png', view: ProductView.back),
      ProductPhoto('assets/products/cabinet-oliver_closeup.png', view: ProductView.closeup),
    ],
    sections: const [
      ProductSection('Основное', [
        'Тип: напольный угловой кухонный модуль',
        'Одна распашная дверца и открытая боковая полка',
        'Столешница под дерево',
      ]),
      ProductSection('Внешний вид', [
        'Корпус белый',
        'Фасад цвета шалфей (#7D8878)',
        'Чёрные ножки-опоры',
      ]),
    ],
  ),
  Product(
    id: 'armchair-marsel',
    name: 'Кресло Марсель',
    category: 'Кресло',
    color: const Color(0xFFE8C03D),
    shop: 'Ozon',
    spec: 'Кресло с высокой спинкой · горчично-жёлтая обивка · деревянные ножки',
    price: 31990,
    url: 'https://www.ozon.ru/product/kreslo-myagkoe-dlya-doma-v-gostinuyu-marsel-w-b-premium-velyur-zheltyy-1994903031/?at=1tar1XVg8aVqMPq_Z9bhx8eWy68XUHOr&sh=P1TZCwY5Ug',
    photos: const [
      ProductPhoto('assets/products/armchair-marsel_front.png', view: ProductView.front),
      ProductPhoto('assets/products/armchair-marsel_side.png', view: ProductView.side),
      ProductPhoto('assets/products/armchair-marsel_closeup.png', view: ProductView.closeup),
    ],
    sections: const [
      ProductSection('Основное', [
        'Тип: кресло с высокой спинкой и подлокотниками',
        'Мягкое сиденье и боковые «ушки» спинки',
        'Стёжка пуговицами на спинке',
      ]),
      ProductSection('Материалы', [
        'Обивка: ткань горчично-жёлтого цвета (#E8C03D)',
        'Ножки деревянные',
      ]),
    ],
  ),
  Product(
    id: 'adel-wall',
    name: 'Стенка Адель',
    category: 'Стенка',
    color: const Color(0xFF8B7355), // тёплый коричневый/бежевый
    shop: 'Столплит',
    spec: 'Напольная стенка · несколько секций · открытые и закрытые отсеки',
    price: 89990,
    url: 'https://www.stolplit.ru/internet-magazin/kupit/117554422-stenka-adel/',
    photos: const [
      ProductPhoto('assets/products/adel-wall_front.png', view: ProductView.front),
      ProductPhoto('assets/products/adel-wall_side.png', view: ProductView.side),
      ProductPhoto('assets/products/adel-wall_back.png', view: ProductView.back),
      ProductPhoto('assets/products/adel-wall_closeup.png', view: ProductView.closeup),
    ],
    sections: const [
      ProductSection('Основное', [
        'Тип: напольная модульная стенка',
        'Несколько секций для хранения и декора',
        'Открытые полки и закрытые отсеки с дверцами',
      ]),
      ProductSection('Материалы', [
        'Корпус: ЛДСП/МДФ',
        'Фасады: МДФ с покрытием',
        'Цвет: тёплый натуральный оттенок',
      ]),
    ],
  ),
];

Product? productById(String id) {
  for (final p in products) {
    if (p.id == id) return p;
  }
  return null;
}

List<String> get productCategories =>
    {for (final p in products) p.category}.toList();
import '../models/quiz_question.dart';

/// Bank soal kurikuler Unit 3: Sandhangan dan Pasangan Aksara Jawa (Node 21–30).
///
/// Materi:
/// - Node 21: Sandhangan Swara (`sandhangan_swara`)
/// - Node 22: Sandhangan Panyigeg Wanda (`sandhangan_panyigeg`)
/// - Node 23: Sandhangan Wyanjana (`sandhangan_wyanjana`)
/// - Node 24: Pengenalan Pasangan Aksara (`pengenalan_pasangan`)
/// - Node 25: Pasangan Sejajar & Gantung (`pasangan_sejajar_gantung`)
/// - Node 26: Maca Tembung mawa Sandhangan (`maca_kata_sandhangan`)
/// - Node 27: Nulis Tembung mawa Pasangan (`nulis_kata_sederhana`)
/// - Node 28: Kaluputan Panyeratan Aksara (`niteni_luput_nulis`)
/// - Node 29: Gladhen Kombinasi Sandhangan & Pasangan (`gladhen_kombinasi`)
/// - Node 30: Evaluasi Komprehensif Unit 3 (`evaluasi_unit3`)
class Unit3Questions {
  Unit3Questions._();

  static const List<QuizQuestion> allQuestions = [
    // =========================================================================
    // NODE 21: Sandhangan Swara (topicKey: 'sandhangan_swara')
    // =========================================================================
    QuizQuestion(
      id: 'u3_n21_q01',
      topicKey: 'sandhangan_swara',
      difficulty: QuizDifficulty.mudah,
      type: QuestionType.glyphIdentify,
      prompt: 'Sandhangan swara kanggo ngowahi dadi swara "i" arane apa?',
      glyph: 'ꦶ',
      options: ['Wulu', 'Suku', 'Taling', 'Pepet'],
      correctIndex: 0,
      explanation:
          'Wulu (ꦶ) manggon ing ndhuwur aksara kanggo ngasilake vokal "i".',
      sourceReference: 'Pepak Basa Jawa: Sandhangan Swara',
    ),
    QuizQuestion(
      id: 'u3_n21_q02',
      topicKey: 'sandhangan_swara',
      difficulty: QuizDifficulty.mudah,
      type: QuestionType.glyphIdentify,
      prompt: 'Sandhangan swara kanggo ngowahi dadi swara "u" arane apa?',
      glyph: 'ꦸ',
      options: ['Taling', 'Suku', 'Pepet', 'Wulu'],
      correctIndex: 1,
      explanation:
          'Suku (ꦸ) manggon ing ngisor aksara kanggo ngasilake vokal "u".',
      sourceReference: 'Pepak Basa Jawa: Sandhangan Swara',
    ),
    QuizQuestion(
      id: 'u3_n21_q03',
      topicKey: 'sandhangan_swara',
      difficulty: QuizDifficulty.mahir,
      type: QuestionType.glyphIdentify,
      prompt: 'Sandhangan taling (ꦺ) gunane kanggo ngasilake swara apa?',
      glyph: 'ꦺ',
      options: ['Swara u', 'Swara i', 'Swara é / è', 'Swara o'],
      correctIndex: 2,
      explanation:
          'Taling (ꦺ) manggon ing sangarepe aksara kanggo ngasilake swara "é" utawa "è".',
      sourceReference: 'Pepak Basa Jawa: Sandhangan Swara',
    ),
    QuizQuestion(
      id: 'u3_n21_q04',
      topicKey: 'sandhangan_swara',
      difficulty: QuizDifficulty.mahir,
      type: QuestionType.glyphIdentify,
      prompt: 'Sandhangan pepet (ꦼ) gunane kanggo ngasilake swara apa?',
      glyph: 'ꦼ',
      options: [
        'Swara e pepet kaya ing tembung sega',
        'Swara a legena kaya ing tembung bata',
        'Swara u suku kaya ing tembung sapu',
        'Swara i wulu kaya ing tembung pari',
      ],
      correctIndex: 0,
      explanation:
          'Pepet (ꦼ) manggon ing ndhuwur aksara ngasilake swara "e" pepet kaya ing "sepet", "sega".',
      sourceReference: 'Pepak Basa Jawa: Sandhangan Swara',
    ),
    QuizQuestion(
      id: 'u3_n21_q05',
      topicKey: 'sandhangan_swara',
      difficulty: QuizDifficulty.sangatMahir,
      type: QuestionType.glyphIdentify,
      prompt:
          'Kanggo nulis swara vokal "o", sandhangan kang digunakake yaiku...',
      glyph: 'ꦺꦴ',
      options: [
        'Taling wae',
        'Tarung wae',
        'Wulu lan suku',
        'Taling-tarung (ꦺ...ꦴ)',
      ],
      correctIndex: 3,
      explanation:
          'Taling-tarung (ꦺ...ꦴ) ngapit aksara kanggo ngasilake swara "o".',
      sourceReference: 'Pedoman Penulisan Sandhangan Swara',
    ),
    QuizQuestion(
      id: 'u3_n21_q06',
      topicKey: 'sandhangan_swara',
      difficulty: QuizDifficulty.sangatMahir,
      type: QuestionType.glyphIdentify,
      prompt: 'Pira cacahe sandhangan swara baku ing aksara Jawa?',
      glyph: 'ꦱ꧀ꦮꦫ',
      options: [
        '5 werna (wulu, suku, taling, pepet, taling-tarung)',
        '3 werna (wulu, suku, taling)',
        '4 werna (wulu, suku, pepet, layar)',
        '6 werna (wulu, suku, taling, pepet, layar, cecak)',
      ],
      correctIndex: 0,
      explanation:
          'Sandhangan swara ana 5: wulu (i), suku (u), taling (é), pepet (e), lan taling-tarung (o).',
      sourceReference: 'Paramasastra Jawa',
    ),

    // =========================================================================
    // NODE 22: Sandhangan Panyigeg Wanda (topicKey: 'sandhangan_panyigeg')
    // =========================================================================
    QuizQuestion(
      id: 'u3_n22_q01',
      topicKey: 'sandhangan_panyigeg',
      difficulty: QuizDifficulty.mudah,
      type: QuestionType.glyphIdentify,
      prompt: 'Sandhangan layar (ꦂ) minangka panyigeg (mateni) konsonan apa?',
      glyph: 'ꦂ',
      options: ['Konsonan r', 'Konsonan h', 'Konsonan ng', 'Konsonan k'],
      correctIndex: 0,
      explanation:
          'Layar (ꦂ) manggon ing ndhuwur aksara kanggo sigeg konsonan "r" (tuladha: pasar).',
      sourceReference: 'Pepak Basa Jawa: Sandhangan Panyigeg',
    ),
    QuizQuestion(
      id: 'u3_n22_q02',
      topicKey: 'sandhangan_panyigeg',
      difficulty: QuizDifficulty.mudah,
      type: QuestionType.glyphIdentify,
      prompt: 'Sandhangan cecak (ꦁ) minangka panyigeg konsonan apa?',
      glyph: 'ꦁ',
      options: ['Konsonan r', 'Konsonan ng', 'Konsonan h', 'Konsonan s'],
      correctIndex: 1,
      explanation:
          'Cecak (ꦁ) manggon ing ndhuwur aksara minangka sigeg konsonan "ng" (tuladha: wayang).',
      sourceReference: 'Pepak Basa Jawa: Sandhangan Panyigeg',
    ),
    QuizQuestion(
      id: 'u3_n22_q03',
      topicKey: 'sandhangan_panyigeg',
      difficulty: QuizDifficulty.mahir,
      type: QuestionType.glyphIdentify,
      prompt: 'Sandhangan wignyan (ꦃ) minangka panyigeg konsonan apa?',
      glyph: 'ꦃ',
      options: ['Konsonan m', 'Konsonan l', 'Konsonan h', 'Konsonan w'],
      correctIndex: 2,
      explanation:
          'Wignyan (ꦃ) manggon ing mburine aksara minangka sigeg konsonan "h" (tuladha: gajah).',
      sourceReference: 'Pepak Basa Jawa: Sandhangan Panyigeg',
    ),
    QuizQuestion(
      id: 'u3_n22_q04',
      topicKey: 'sandhangan_panyigeg',
      difficulty: QuizDifficulty.mahir,
      type: QuestionType.glyphIdentify,
      prompt: 'Sandhangan pangkon (꧀) gunane yaiku kanggo...',
      glyph: '꧀',
      options: [
        'Mateni aksara ing pungkasan ukara utawa tembung',
        'Nambahi swara vokal ing satengahing wanda',
        'Menehi tandha pitakon ing pungkasan ukara',
        'Ngganteni aksara legena dadi aksara murda',
      ],
      correctIndex: 0,
      explanation:
          'Pangkon (꧀) kanggo mateni vokal aksara legena dadi konsonan mati ing pungkasan ukara.',
      sourceReference: 'Pepak Basa Jawa: Sandhangan Panyigeg',
    ),
    QuizQuestion(
      id: 'u3_n22_q05',
      topicKey: 'sandhangan_panyigeg',
      difficulty: QuizDifficulty.sangatMahir,
      type: QuestionType.glyphIdentify,
      prompt: 'Sandhangan panyigeg wanda cacahe ana 4, yaiku...',
      glyph: 'ꦥꦚꦶꦒꦼꦒ꧀',
      options: [
        'Wulu, suku, taling, pepet',
        'Cakra, keret, pengkal, cecek',
        'Wignyan, layar, cecak, pangkon',
        'Pangkon, pada, adeg-adeg, carik',
      ],
      correctIndex: 2,
      explanation:
          'Sandhangan panyigeg wanda ana 4: wignyan (h), layar (r), cecak (ng), lan pangkon.',
      sourceReference: 'Pedoman Ejaan Jawa',
    ),
    QuizQuestion(
      id: 'u3_n22_q06',
      topicKey: 'sandhangan_panyigeg',
      difficulty: QuizDifficulty.sangatMahir,
      type: QuestionType.glyphIdentify,
      prompt:
          'Apa sebabe tembung "pasar" ora kena ditulis nganggo aksara ꦫ dipangkon (ꦥꦱꦫ꧀)?',
      glyph: 'ꦥꦱꦂ',
      options: [
        'Amarga wis ana sandhangan layar (ꦂ) minangka panyigeging aksara Ra',
        'Amarga wis ana sandhangan wignyan (ꦃ) minangka panyigeging aksara Ra',
        'Amarga wis ana sandhangan cecak (ꦁ) minangka panyigeging aksara Ra',
        'Amarga aksara Ra kudu ditulis nganggo pasangan Ra ing sangarepe',
      ],
      correctIndex: 0,
      explanation:
          'Cakra (ꦿ) nambahi unine konsonan "ra" ing satengahing wanda (tuladha: ꦥꦿ = pra).',
      sourceReference: 'Pepak Basa Jawa: Sandhangan Wyanjana',
    ),
    QuizQuestion(
      id: 'u3_n23_q01',
      topicKey: 'sandhangan_wyanjana',
      difficulty: QuizDifficulty.mudah,
      type: QuestionType.glyphIdentify,
      prompt: 'Sandhangan cakra (ꦿ) nambahi seselan konsonan apa?',
      glyph: 'ꦿ',
      options: ['-r-', '-y-', '-w-', '-l-'],
      correctIndex: 0,
      explanation:
          'Sandhangan cakra mènèhi seselan konsonan -r- ing sawijining wanda.',
      sourceReference: 'Wewaton Panulise Basa Jawa',
    ),
    QuizQuestion(
      id: 'u3_n23_q02',
      topicKey: 'sandhangan_wyanjana',
      difficulty: QuizDifficulty.mudah,
      type: QuestionType.glyphIdentify,
      prompt: 'Sandhangan pengkal (ꦾ) nambahi seselan konsonan apa?',
      glyph: 'ꦾ',
      options: ['Seselan -ra-', 'Seselan -ya-', 'Seselan -re-', 'Seselan -ng-'],
      correctIndex: 1,
      explanation:
          'Pengkal (ꦾ) nambahi konsonan "ya" ing satengahing wanda (tuladha: ꦏꦾ = kya).',
      sourceReference: 'Pepak Basa Jawa: Sandhangan Wyanjana',
    ),
    QuizQuestion(
      id: 'u3_n23_q03',
      topicKey: 'sandhangan_wyanjana',
      difficulty: QuizDifficulty.mahir,
      type: QuestionType.glyphIdentify,
      prompt: 'Sandhangan cakra keret (ꦽ) ngganteni seselan apa?',
      glyph: 'ꦽ',
      options: [
        'Cakra kawuwuhan wulu',
        'Cakra kawuwuhan suku',
        'Cakra kawuwuhan pepet (-re pepet)',
        'Cakra kawuwuhan layar',
      ],
      correctIndex: 2,
      explanation:
          'Cakra keret (ꦽ) ngganteni cakra + pepet kanggo ngasilake swara "re" pepet (tuladha: kreteg).',
      sourceReference: 'Pedoman Penulisan Sandhangan Wyanjana',
    ),
    QuizQuestion(
      id: 'u3_n23_q04',
      topicKey: 'sandhangan_wyanjana',
      difficulty: QuizDifficulty.mahir,
      type: QuestionType.glyphIdentify,
      prompt:
          'Tembung "krasa" yen katulis aksara Jawa nggunakake sandhangan...',
      glyph: 'ꦏꦿꦱ',
      options: ['Cakra (ꦿ)', 'Pengkal (ꦾ)', 'Wulu (ꦶ)', 'Layar (ꦂ)'],
      correctIndex: 0,
      explanation:
          '"Kra" ditulis aksara ka kawuwuhan cakra dadi ꦏꦿ, banjur ꦱ (sa).',
      sourceReference: 'Pedoman Penulisan Sandhangan Wyanjana',
    ),
    QuizQuestion(
      id: 'u3_n23_q05',
      topicKey: 'sandhangan_wyanjana',
      difficulty: QuizDifficulty.sangatMahir,
      type: QuestionType.glyphIdentify,
      prompt: 'Tembung "kreteg" ditulis nggunakake sandhangan wyanjana apa?',
      glyph: 'ꦏꦽꦠꦼꦒ꧀',
      options: [
        'Cakra wae',
        'Cakra lan pepet dhewe-dhewe',
        'Cakra keret (ꦽ)',
        'Pengkal lan suku',
      ],
      correctIndex: 2,
      explanation:
          'Swara "kre" pepet kudu ditulis nganggo cakra keret (ꦏꦽ), ora kena cakra kawuwuhan pepet.',
      sourceReference: 'Paugeran Pasangon Aksara Jawa',
    ),
    QuizQuestion(
      id: 'u3_n23_q06',
      topicKey: 'sandhangan_wyanjana',
      difficulty: QuizDifficulty.sangatMahir,
      type: QuestionType.glyphIdentify,
      prompt: 'Tembung "widya" ditulis nggunakake sandhangan wyanjana...',
      glyph: 'ꦮꦶꦢꦾ',
      options: ['Cakra', 'Pengkal (ꦾ)', 'Cakra keret', 'Cecak'],
      correctIndex: 1,
      explanation: 'Aksara da kawuwuhan pengkal dadi ꦢꦾ (dya).',
      sourceReference: 'Paugeran Pasangon Aksara Jawa',
    ),

    // =========================================================================
    // NODE 24: Pengenalan Pasangan (topicKey: 'pengenalan_pasangan')
    // =========================================================================
    QuizQuestion(
      id: 'u3_n24_q01',
      topicKey: 'pengenalan_pasangan',
      difficulty: QuizDifficulty.mudah,
      type: QuestionType.glyphIdentify,
      prompt: 'Apa fungsi utama pasangan ing panulisan aksara Jawa?',
      glyph: '',
      options: [
        'Mateni aksara legena sadurunge ing satengahing tembung utawa ukara',
        'Nambahi swara vokal u ing pungkasan wanda aksara legena',
        'Menehi tandha wacana titik utawa koma ing pungkasan ukara',
        'Ngganteni aksara legena dadi aksara murda utawa aksara swara',
      ],
      correctIndex: 0,
      explanation:
          'Pasangan digunakake kanggo mateni vokal aksara sadurunge tanpa nggunakake pangkon ing tengah.',
      sourceReference: 'Pepak Basa Jawa: Pasangan Aksara',
    ),
    QuizQuestion(
      id: 'u3_n24_q02',
      topicKey: 'pengenalan_pasangan',
      difficulty: QuizDifficulty.mudah,
      type: QuestionType.glyphIdentify,
      prompt: 'Pira cacahe pasangan aksara Jawa?',
      glyph: '',
      options: [
        '20 pasangan (cocog karo cacahe aksara carakan legena)',
        '10 pasangan (mung kanggo aksara kang nduweni sikil)',
        '18 pasangan (ora kalebu aksara legena kang sigeg)',
        '24 pasangan (kacampuran aksara murda lan swara)',
      ],
      correctIndex: 0,
      explanation:
          'Saben aksara legena kang cacahe 20 nduweni pasangan dhewe-dhewe (gancaran 20 pasangan).',
      sourceReference: 'Pepak Basa Jawa: Pasangan Aksara',
    ),
    QuizQuestion(
      id: 'u3_n24_q03',
      topicKey: 'pengenalan_pasangan',
      difficulty: QuizDifficulty.mahir,
      type: QuestionType.glyphIdentify,
      prompt: 'Pangkon (꧀) lumrahe ora kena digunakake ing...',
      glyph: '',
      options: [
        'Satengahing tembung utawa satengahing ukara lumrah',
        'Pungkasaning ukara sadurunge tandha pada lingsa',
        'Pungkasaning paragraf minangka panutup wacana',
        'Wiwasananing angka Jawa ing panulisan tanggalan',
      ],
      correctIndex: 0,
      explanation:
          'Ing tengah tembung/ukara ora kena nganggo pangkon, nanging kudu nggunakake pasangan aksara.',
      sourceReference: 'Paugeran Panyeratan Aksara Jawa',
    ),
    QuizQuestion(
      id: 'u3_n24_q04',
      topicKey: 'pengenalan_pasangan',
      difficulty: QuizDifficulty.mahir,
      type: QuestionType.glyphIdentify,
      prompt:
          'Nalika aksara sigeg ketemu aksara candhake, aksara candhake kasebut ditulis awujud...',
      glyph: '',
      options: ['Pasangan', 'Aksara swara', 'Aksara murda', 'Angka'],
      correctIndex: 0,
      explanation:
          'Aksara candhake malih dadi wujud pasangane amarga aksara sadurunge mati.',
      sourceReference: 'Paramasastra Jawa',
    ),
    QuizQuestion(
      id: 'u3_n24_q05',
      topicKey: 'pengenalan_pasangan',
      difficulty: QuizDifficulty.sangatMahir,
      type: QuestionType.glyphIdentify,
      prompt: 'Ing kahanan apa pangkon oleh manggon ing tengah ukara?',
      glyph: '',
      options: [
        'Nalika dadi gantine tandha koma sauntara utawa ngedohi tumpuk telu',
        'Nalika nulis jeneng kutha utawa jeneng wong kang kinurmatan',
        'Saben ana aksara carakan legena kang manggon ing ngarep ukara',
        'Babar blas ora ana kahanan kang ngolehake pangkon ing tengah',
      ],
      correctIndex: 0,
      explanation:
          'Pangkon oleh ing tengah minangka tandha pambagi (koma) utawa ngindhari tumpuk telu.',
      sourceReference:
          'Pedoman Umum Pasangon Aksara Jawa (Kongres Bahasa Jawa)',
    ),
    QuizQuestion(
      id: 'u3_n24_q06',
      topicKey: 'pengenalan_pasangan',
      difficulty: QuizDifficulty.sangatMahir,
      type: QuestionType.glyphIdentify,
      prompt:
          'Aksara Jawa kang wujud pasangane padha persis karo aksara asline yaiku...',
      glyph: '',
      options: ['Aksara ꦲ', 'Aksara ꦫ (꧀ꦫ)', 'Aksara ꦤ', 'Aksara ꦏ'],
      correctIndex: 1,
      explanation:
          'Pasangan ꦫ wujude padha persis karo aksarane asline, manggon ing ngisor aksara mati.',
      sourceReference: 'Tipografi Pasangan Aksara Jawa',
    ),

    // =========================================================================
    // NODE 25: Pasangan Sejajar & Gantung (topicKey: 'penggunaan_pasangan')
    // =========================================================================
    QuizQuestion(
      id: 'u3_n25_q01',
      topicKey: 'penggunaan_pasangan',
      difficulty: QuizDifficulty.mudah,
      type: QuestionType.glyphIdentify,
      prompt:
          'Pasangan aksara Jawa kang manggon sejajar (ing sisihe) aksara mati yaiku pasangan...',
      glyph: '',
      options: ['Ha, Sa, Pa', 'Na, Ca, Ra', 'Da, Ta, La', 'Ma, Ga, Ba'],
      correctIndex: 0,
      explanation:
          'Pasangan kang manggon sejajar ing tengen aksara yaiku pasangan ꦲ (ha), ꦱ (sa), lan ꦥ (pa).',
      sourceReference: 'Pepak Basa Jawa: Pasangan Sejajar',
    ),
    QuizQuestion(
      id: 'u3_n25_q02',
      topicKey: 'penggunaan_pasangan',
      difficulty: QuizDifficulty.mudah,
      type: QuestionType.glyphIdentify,
      prompt: 'Akeh-akehe pasangan aksara Jawa manggone ana ing...',
      glyph: '',
      options: [
        'Ing ndhuwure aksara mati',
        'Ing ngisore aksara mati (gantung)',
        'Ing jero aksara',
        'Ing mburi ukara',
      ],
      correctIndex: 1,
      explanation:
          'Sebagean gedhe pasangan aksara Jawa manggon gantung ing ngisore aksara kang dipateni.',
      sourceReference: 'Pepak Basa Jawa: Pasangan Gantung',
    ),
    QuizQuestion(
      id: 'u3_n25_q03',
      topicKey: 'penggunaan_pasangan',
      difficulty: QuizDifficulty.mahir,
      type: QuestionType.glyphIdentify,
      prompt: 'Pasangan ꦥ (pa) yen ditulis manggone ana ing...',
      glyph: '',
      options: [
        'Ing ngisor aksara mati',
        'Sejajar ing sisih tengene aksara mati',
        'Ing ndhuwur aksara mati',
        'Ing tengah aksara',
      ],
      correctIndex: 1,
      explanation:
          'Pasangan ꦥ kalebu pasangan sejajar (jejer) bebarengan karo ꦲ lan ꦱ.',
      sourceReference: 'Pedoman Penulisan Pasangan',
    ),
    QuizQuestion(
      id: 'u3_n25_q04',
      topicKey: 'penggunaan_pasangan',
      difficulty: QuizDifficulty.mahir,
      type: QuestionType.glyphIdentify,
      prompt: 'Pasangan ꦏ (ka) yen katulis manggone ana ing...',
      glyph: '',
      options: [
        'Ing ngisore aksara mati (gantung)',
        'Sejajar ing tengen',
        'Ing ndhuwur aksara',
        'Ing ngarep aksara',
      ],
      correctIndex: 0,
      explanation: 'Pasangan ꦏ manggon ing ngisore aksara mati.',
      sourceReference: 'Pedoman Penulisan Pasangan',
    ),
    QuizQuestion(
      id: 'u3_n25_q05',
      topicKey: 'penggunaan_pasangan',
      difficulty: QuizDifficulty.sangatMahir,
      type: QuestionType.glyphIdentify,
      prompt:
          'Yen pasangan sejajar (kaya pasangan ꦱ) kawuwuhan sandhangan suku (u), manggone suku ana ing...',
      glyph: '',
      options: [
        'Ing aksara mati sadurunge',
        'Ing ngisor buntute pasangan ꦱ kasebut',
        'Ora bisa diwenehi suku',
        'Pindhah menyang ndhuwur',
      ],
      correctIndex: 1,
      explanation:
          'Sandhangan suku tumrap pasangan sejajar tumemplek ing ngisor buntut pasangane.',
      sourceReference: 'Paugeran Pasangon Aksara Jawa',
    ),
    QuizQuestion(
      id: 'u3_n25_q06',
      topicKey: 'penggunaan_pasangan',
      difficulty: QuizDifficulty.sangatMahir,
      type: QuestionType.glyphIdentify,
      prompt:
          'Pasangan aksara kang ngalami owah-owahan wujud dadi wutuh maneh nalika kawuwuhan sandhangan suku yaiku...',
      glyph: '',
      options: ['Pasangan ꦠ lan ꦭ', 'Pasangan ꦲ', 'Pasangan ꦔ', 'Pasangan ꦫ'],
      correctIndex: 0,
      explanation:
          'Pasangan ꦠ lan ꦭ yen oleh sandhangan suku, wujude mbalek wutuh kaya aksarane amarga gandheng suku.',
      sourceReference: 'Kongres Basa Jawa: Paugeran Sriwedari',
    ),

    // =========================================================================
    // NODE 26: Maca Tembung mawa Sandhangan (topicKey: 'maca_kata_sandhangan')
    // =========================================================================
    QuizQuestion(
      id: 'u3_n26_q01',
      topicKey: 'maca_kata_sandhangan',
      difficulty: QuizDifficulty.mudah,
      type: QuestionType.glyphIdentify,
      prompt: 'Tembung iki wacane kepriye?',
      glyph: 'ꦱꦶꦠꦶ',
      options: ['Siti', 'Sutu', 'Sete', 'Soto'],
      correctIndex: 0,
      explanation: 'Aksara sa diwulu (si) + ta diwulu (ti) = "Siti".',
      sourceReference: 'Sinau Maca Sandhangan',
    ),
    QuizQuestion(
      id: 'u3_n26_q02',
      topicKey: 'maca_kata_sandhangan',
      difficulty: QuizDifficulty.mudah,
      type: QuestionType.glyphIdentify,
      prompt: 'Tembung iki wacane kepriye?',
      glyph: 'ꦧꦸꦏꦸ',
      options: ['Bata', 'Buku', 'Biku', 'Buka'],
      correctIndex: 1,
      explanation: 'Aksara ba disuku (bu) + ka disuku (ku) = "Buku".',
      sourceReference: 'Sinau Maca Sandhangan',
    ),
    QuizQuestion(
      id: 'u3_n26_q03',
      topicKey: 'maca_kata_sandhangan',
      difficulty: QuizDifficulty.mahir,
      type: QuestionType.glyphIdentify,
      prompt: 'Tembung iki wacane kepriye?',
      glyph: 'ꦥꦱꦂ',
      options: ['Pasar', 'Pasa', 'Pari', 'Pasir'],
      correctIndex: 0,
      explanation: 'Aksara pa + sa dilayar (sar) = "Pasar".',
      sourceReference: 'Sinau Maca Sandhangan Panyigeg',
    ),
    QuizQuestion(
      id: 'u3_n26_q04',
      topicKey: 'maca_kata_sandhangan',
      difficulty: QuizDifficulty.mahir,
      type: QuestionType.glyphIdentify,
      prompt: 'Tembung iki wacane kepriye?',
      glyph: 'ꦏꦕꦁ',
      options: ['Kaca', 'Kacang', 'Kancing', 'Kucing'],
      correctIndex: 1,
      explanation: 'Aksara ka + ca dicecak (cang) = "Kacang".',
      sourceReference: 'Sinau Maca Sandhangan Panyigeg',
    ),
    QuizQuestion(
      id: 'u3_n26_q05',
      topicKey: 'maca_kata_sandhangan',
      difficulty: QuizDifficulty.sangatMahir,
      type: QuestionType.glyphIdentify,
      prompt: 'Tembung iki wacane kepriye?',
      glyph: 'ꦒꦗꦃ',
      options: ['Gajah', 'Gaja', 'Gajah mada', 'Gajah lara'],
      correctIndex: 0,
      explanation: 'Aksara ga + ja diwignyan (jah) = "Gajah".',
      sourceReference: 'Sinau Maca Sandhangan Panyigeg',
    ),
    QuizQuestion(
      id: 'u3_n26_q06',
      topicKey: 'maca_kata_sandhangan',
      difficulty: QuizDifficulty.sangatMahir,
      type: QuestionType.glyphIdentify,
      prompt: 'Tembung iki wacane kepriye?',
      glyph: 'ꦭꦺꦴꦩ꧀ꦧꦺꦴꦏ꧀',
      options: ['Lontong', 'Lombok', 'Lembut', 'Lompat'],
      correctIndex: 1,
      explanation:
          'La taling-tarung (lo) + ma dipasangi ba taling-tarung (mbo) + ka dipangkon (k) = "Lombok".',
      sourceReference: 'Sinau Maca Aksara Jawa Kompleks',
    ),

    // =========================================================================
    // NODE 27: Nulis Tembung mawa Pasangan (topicKey: 'nulis_kata_sederhana')
    // =========================================================================
    QuizQuestion(
      id: 'u3_n27_q01',
      topicKey: 'nulis_kata_sederhana',
      difficulty: QuizDifficulty.mudah,
      type: QuestionType.textToAksara,
      prompt: 'Tembung "mangan sega" mbutuhake pasangan aksara apa?',
      glyph: '',
      options: [
        'Pasangan sa (꧀ꦱ)',
        'Pasangan ma (꧀ꦩ)',
        'Pasangan nga (꧀ꦔ)',
        'Pasangan ga (꧀ꦒ)',
      ],
      correctIndex: 0,
      explanation:
          'Aksara na mati amarga ketemu tembung "sega", mula aksara sa katulis dadi pasangan ꧀ꦱ.',
      sourceReference: 'Paugeran Nulis Pasangan Aksara',
    ),
    QuizQuestion(
      id: 'u3_n27_q02',
      topicKey: 'nulis_kata_sederhana',
      difficulty: QuizDifficulty.mudah,
      type: QuestionType.textToAksara,
      prompt: 'Tembung "tumbuk pari" mbutuhake pasangan aksara apa?',
      glyph: '',
      options: [
        'Pasangan ba lan pasangan pa',
        'Pasangan ta lan ka',
        'Pasangan ra lan ma',
        'Pasangan nga lan wa',
      ],
      correctIndex: 0,
      explanation:
          '"Tum-buk" mbutuhake pasangan ba (꧀ꦧ), "buk-pa" mbutuhake pasangan pa (꧀ꦥ).',
      sourceReference: 'Paugeran Nulis Pasangan Aksara',
    ),
    QuizQuestion(
      id: 'u3_n27_q03',
      topicKey: 'nulis_kata_sederhana',
      difficulty: QuizDifficulty.mahir,
      type: QuestionType.textToAksara,
      prompt: 'Tembung "anak sapi" yen katulis mawa aksara Jawa yaiku...',
      glyph: '',
      options: ['ꦲꦤꦏ꧀ꦱꦥꦶ', 'ꦲꦤꦏ꧀ꦱꦥ', 'ꦲꦤꦱꦥꦶ', 'ꦲꦤꦏꦱꦥꦶ'],
      correctIndex: 0,
      explanation:
          'Aksara ka dipasangi sa sejajar, banjur pa kawuwuhan wulu (ꦥꦶ) = anak sapi.',
      sourceReference: 'Gladhen Nulis Aksara Jawa',
    ),
    QuizQuestion(
      id: 'u3_n27_q04',
      topicKey: 'nulis_kata_sederhana',
      difficulty: QuizDifficulty.mahir,
      type: QuestionType.textToAksara,
      prompt: 'Tembung "bapak tindak" mbutuhake pasangan aksara...',
      glyph: '',
      options: [
        'Pasangan ba',
        'Pasangan ta (꧀ꦠ)',
        'Pasangan da',
        'Pasangan ka',
      ],
      correctIndex: 1,
      explanation:
          'Konsonan k ing pungkasan tembung "bapak" dipateni kanthi masang aksara ta (꧀ꦠ).',
      sourceReference: 'Gladhen Nulis Aksara Jawa',
    ),
    QuizQuestion(
      id: 'u3_n27_q05',
      topicKey: 'nulis_kata_sederhana',
      difficulty: QuizDifficulty.sangatMahir,
      type: QuestionType.textToAksara,
      prompt:
          'Panulisan "adhik tuku" kang bener yaiku aksara ka mati amarga...',
      glyph: '',
      options: [
        'Dipangkon ing tengah tembung',
        'Kawuwuhan layar',
        'Dipasangi aksara ta kawuwuhan suku (꧀ꦠꦸ)',
        'Dibusak aksara kane',
      ],
      correctIndex: 2,
      explanation:
          'Aksara ka mati amarga dipasangi pasangan ta mawa suku dadi ꧀ꦠꦸ.',
      sourceReference: 'Tata Tulis Pasangan Aksara Jawa',
    ),
    QuizQuestion(
      id: 'u3_n27_q06',
      topicKey: 'nulis_kata_sederhana',
      difficulty: QuizDifficulty.sangatMahir,
      type: QuestionType.textToAksara,
      prompt: 'Ukara "mangan nanas" ngemot pasangan aksara apa?',
      glyph: '',
      options: [
        'Pasangan ma',
        'Pasangan na (꧀ꦤ)',
        'Pasangan sa',
        'Pasangan ga',
      ],
      correctIndex: 1,
      explanation:
          'Aksara na ing tembung "mangan" dipateni kanthi pasangan na (꧀ꦤ) saka tembung "nanas".',
      sourceReference: 'Tata Tulis Pasangan Aksara Jawa',
    ),

    // =========================================================================
    // NODE 28: Kaluputan Panyeratan (topicKey: 'niteni_luput_nulis')
    // =========================================================================
    QuizQuestion(
      id: 'u3_n28_q01',
      topicKey: 'niteni_luput_nulis',
      difficulty: QuizDifficulty.mudah,
      type: QuestionType.glyphIdentify,
      prompt:
          'Kaluputan apa kang asring dumadi nalika wong sinau nulis aksara Jawa?',
      glyph: '',
      options: [
        'Nggunakake sandhangan pangkon ing tengahing tembung',
        'Nggunakake sandhangan wulu ing pungkasane tembung',
        'Nulis pasangan aksara ing sangisore aksara sigeg',
        'Nambahi sandhangan layar ing aksara kang wis mati',
      ],
      correctIndex: 0,
      explanation:
          'Pangkon ora kena ing tengah ukara, kudu diganti pasangan aksara.',
      sourceReference: 'Wawaton Sriwedari: Kaluputan Panyeratan',
    ),
    QuizQuestion(
      id: 'u3_n28_q02',
      topicKey: 'niteni_luput_nulis',
      difficulty: QuizDifficulty.mudah,
      type: QuestionType.glyphIdentify,
      prompt:
          'Swara "re" pepet ora kena ditulis aksara ra dipepet (ꦫꦼ), nanging kudu ditulis...',
      glyph: '',
      options: ['Pa cerek (ꦉ)', 'Nga lelet (ꦊ)', 'Cakra keret', 'Layar'],
      correctIndex: 0,
      explanation:
          'Swara "re" pepet minangka suku kata mandhiri kudu ditulis nganggo Pa cerek (ꦉ).',
      sourceReference: 'Pepak Basa Jawa: Pa Cerek & Nga Lelet',
    ),
    QuizQuestion(
      id: 'u3_n28_q03',
      topicKey: 'niteni_luput_nulis',
      difficulty: QuizDifficulty.mahir,
      type: QuestionType.glyphIdentify,
      prompt: 'Semono uga swara "le" pepet kudu ditulis nggunakake...',
      glyph: '',
      options: [
        'La dipepet (ꦭꦼ)',
        'Nga lelet (ꦊ)',
        'Pa cerek (ꦉ)',
        'Cakra keret',
      ],
      correctIndex: 1,
      explanation:
          'Swara "le" pepet kudu ditulis nganggo Nga lelet (ꦊ), ora kena aksara la kawuwuhan pepet.',
      sourceReference: 'Pepak Basa Jawa: Pa Cerek & Nga Lelet',
    ),
    QuizQuestion(
      id: 'u3_n28_q04',
      topicKey: 'niteni_luput_nulis',
      difficulty: QuizDifficulty.mahir,
      type: QuestionType.glyphIdentify,
      prompt:
          'Aksara sigeg ing pungkasaning tembung "wayang" kudu ditulis nganggo cecak (ꦁ), ora kena...',
      glyph: '',
      options: [
        'Aksara nga dipangkon (ꦔ꧀)',
        'Aksara cecak (ꦁ)',
        'Aksara layar (ꦂ)',
        'Aksara wignyan (ꦃ)',
      ],
      correctIndex: 0,
      explanation:
          'Konsonan sigeg ng kudu ditulis cecak (ꦁ), dilarang nulis aksara nga mawa pangkon ing mburi.',
      sourceReference: 'Paugeran Pasangon Aksara Jawa',
    ),
    QuizQuestion(
      id: 'u3_n28_q05',
      topicKey: 'niteni_luput_nulis',
      difficulty: QuizDifficulty.sangatMahir,
      type: QuestionType.glyphIdentify,
      prompt:
          'Apa sebabe ora kena ana "pasangan tumpuk telu" ing panulisan aksara Jawa?',
      glyph: '',
      options: [
        'Amarga ndadekake aksara angel diwaca lan nalisir saka paugeran Sriwedari',
        'Amarga ngentekake papan panyeratan lan boros mangsi ing kertas',
        'Amarga aksara pasangan bakal owah swarane dadi aksara murda',
        'Amarga paugeran Jawa ora ngidini anane tandha wacan apa wae',
      ],
      correctIndex: 0,
      explanation:
          'Tumpuk telu (aksara mati loro kanthi pasangan dobel) nalisir saka estetika lan paugeran Sriwedari; aksara mati sepisanan kudu dipangkon.',
      sourceReference: 'Wawaton Pasangon Aksara Jawa Sriwedari 1926',
    ),
    QuizQuestion(
      id: 'u3_n28_q06',
      topicKey: 'niteni_luput_nulis',
      difficulty: QuizDifficulty.sangatMahir,
      type: QuestionType.glyphIdentify,
      prompt:
          'Tembung "weruh" yen ditulis aksara wa dipepet lan dilayar (ꦮꦼꦂ) bener utawa luput?',
      glyph: '',
      options: [
        'Bener, amarga pepet lan layar bisa bebarengan ing dhuwure aksara wa',
        'Luput, kudune aksara ra dipangkon',
        'Luput, kudune nganggo pa cerek',
        'Luput, kudune nganggo cakra',
      ],
      correctIndex: 0,
      explanation:
          'Bener, aksara wa kawuwuhan pepet lan layar manggon bebarengan ing ndhuwur dadi "wer".',
      sourceReference: 'Paugeran Pasangon Aksara Jawa',
    ),

    // =========================================================================
    // NODE 29: Gladhen Kombinasi (topicKey: 'gladhen_kombinasi')
    // =========================================================================
    QuizQuestion(
      id: 'u3_n29_q01',
      topicKey: 'gladhen_kombinasi',
      difficulty: QuizDifficulty.mudah,
      type: QuestionType.glyphIdentify,
      prompt: 'Ukara iki wacane kepriye?',
      glyph: 'ꦱꦶꦠꦶꦱꦼꦤꦼꦁꦩꦕ',
      options: [
        'Siti seneng maca',
        'Siti seneng nulis',
        'Siti tuku buku',
        'Siti mangan sega',
      ],
      correctIndex: 0,
      explanation:
          'ꦱꦶꦠꦶ (Siti) + ꦱꦼꦤꦼꦁ (seneng) + ꦩꦕ (maca) = "Siti seneng maca".',
      sourceReference: 'Gladhen Maca Ukara Aksara Jawa',
    ),
    QuizQuestion(
      id: 'u3_n29_q02',
      topicKey: 'gladhen_kombinasi',
      difficulty: QuizDifficulty.mudah,
      type: QuestionType.glyphIdentify,
      prompt: 'Ukara iki wacane kepriye?',
      glyph: 'ꦧꦥꦏ꧀ꦠꦶꦤ꧀ꦢꦏ꧀',
      options: ['Bapak tindak', 'Bapak rawuh', 'Bapak sare', 'Bapak dhahar'],
      correctIndex: 0,
      explanation: 'ꦧꦥꦏ꧀ꦠꦶꦤ꧀ꦢꦏ꧀ wacane "Bapak tindak".',
      sourceReference: 'Gladhen Maca Ukara Aksara Jawa',
    ),
    QuizQuestion(
      id: 'u3_n29_q03',
      topicKey: 'gladhen_kombinasi',
      difficulty: QuizDifficulty.mahir,
      type: QuestionType.glyphIdentify,
      prompt: 'Ukara iki wacane kepriye?',
      glyph: 'ꦲꦶꦧꦸꦠꦸꦩ꧀ꦧꦱ꧀ꦧꦼꦫꦱ꧀',
      options: [
        'Ibu tumbas beras',
        'Ibu masak sega',
        'Ibu tindak pasar',
        'Ibu mundhut gula',
      ],
      correctIndex: 0,
      explanation:
          'ꦲꦶꦧꦸ (Ibu) + ꦠꦸꦩ꧀ꦧꦱ꧀ (tumbas) + ꦧꦼꦫꦱ꧀ (beras) = "Ibu tumbas beras".',
      sourceReference: 'Gladhen Maca Ukara Aksara Jawa',
    ),
    QuizQuestion(
      id: 'u3_n29_q04',
      topicKey: 'gladhen_kombinasi',
      difficulty: QuizDifficulty.mahir,
      type: QuestionType.glyphIdentify,
      prompt: 'Ukara iki wacane kepriye?',
      glyph: 'ꦏꦸꦕꦶꦁꦥꦸꦠꦶꦃ',
      options: [
        'Kucing ireng',
        'Kucing putih',
        'Kelinci putih',
        'Kucing belang',
      ],
      correctIndex: 1,
      explanation:
          'ꦏꦸꦕꦶꦁ (kucing) + ꦥꦸꦠꦶꦃ (putih mawa wignyan) = "kucing putih".',
      sourceReference: 'Gladhen Maca Ukara Aksara Jawa',
    ),
    QuizQuestion(
      id: 'u3_n29_q05',
      topicKey: 'gladhen_kombinasi',
      difficulty: QuizDifficulty.sangatMahir,
      type: QuestionType.glyphIdentify,
      prompt: 'Ukara iki wacane kepriye?',
      glyph: 'ꦏꦿꦺꦠꦥꦸꦭꦁ',
      options: ['Kerta mulih', 'Kréta pulang', 'Kreteg jebol', 'Kraton mulya'],
      correctIndex: 1,
      explanation:
          'ꦏꦿꦺ (kre mawa taling lan cakra) + ꦠ (ta) + ꦥꦸꦭꦁ (pulang) = "kréta pulang".',
      sourceReference: 'Gladhen Maca Ukara Aksara Jawa Kompleks',
    ),
    QuizQuestion(
      id: 'u3_n29_q06',
      topicKey: 'gladhen_kombinasi',
      difficulty: QuizDifficulty.sangatMahir,
      type: QuestionType.glyphIdentify,
      prompt: 'Ukara iki wacane kepriye?',
      glyph: 'ꦚꦩ꧀ꦧꦸꦠ꧀ꦒꦮꦺ',
      options: [
        'Nyambut gawe',
        'Nandur pari',
        'Ngombe wedang',
        'Mangkat sekolah',
      ],
      correctIndex: 0,
      explanation:
          'ꦚ (nya) + ꦩ (ma dipasangi ba mawa suku: mbu) + ꦠ (ta dipasangi ga: tga) + ꦮꦺ (we taling) = "nyambut gawe".',
      sourceReference: 'Gladhen Maca Ukara Aksara Jawa',
    ),

    // =========================================================================
    // NODE 30: Evaluasi Unit 3 (topicKey: 'evaluasi_unit3') - 10 Soal Komprehensif
    // =========================================================================
    QuizQuestion(
      id: 'u3_n30_q01',
      topicKey: 'evaluasi_unit3',
      difficulty: QuizDifficulty.mudah,
      type: QuestionType.glyphIdentify,
      prompt: '[Evaluasi U3] Sandhangan wulu (ꦶ) ngasilake swara apa?',
      glyph: '',
      options: ['Swara i', 'Swara u', 'Swara e', 'Swara o'],
      correctIndex: 0,
      explanation: 'Wulu ngowahi dadi swara vokal "i".',
      sourceReference: 'Evaluasi Unit 3 JawaLoka',
    ),
    QuizQuestion(
      id: 'u3_n30_q02',
      topicKey: 'evaluasi_unit3',
      difficulty: QuizDifficulty.mudah,
      type: QuestionType.glyphIdentify,
      prompt: '[Evaluasi U3] Sandhangan suku (ꦸ) ngasilake swara apa?',
      glyph: '',
      options: ['Swara i', 'Swara u', 'Swara o', 'Swara e'],
      correctIndex: 1,
      explanation: 'Suku manggon ing ngisor ngasilake swara vokal "u".',
      sourceReference: 'Evaluasi Unit 3 JawaLoka',
    ),
    QuizQuestion(
      id: 'u3_n30_q03',
      topicKey: 'evaluasi_unit3',
      difficulty: QuizDifficulty.mudah,
      type: QuestionType.glyphIdentify,
      prompt:
          '[Evaluasi U3] Sandhangan layar (ꦂ) minangka panyigeg konsonan apa?',
      glyph: '',
      options: ['Konsonan h', 'Konsonan ng', 'Konsonan r', 'Konsonan k'],
      correctIndex: 2,
      explanation: 'Layar mateni dadi konsonan "r".',
      sourceReference: 'Evaluasi Unit 3 JawaLoka',
    ),
    QuizQuestion(
      id: 'u3_n30_q04',
      topicKey: 'evaluasi_unit3',
      difficulty: QuizDifficulty.mahir,
      type: QuestionType.glyphIdentify,
      prompt:
          '[Evaluasi U3] Ing ukara "Siti tuku buku", tembung "Siti" lan "buku" nggunakake sandhangan swara awujud...',
      glyph: '',
      options: [
        'Wulu (ꦶ) kanggo Siti, lan suku (ꦸ) kanggo buku',
        'Taling (ꦺ) kanggo Siti, lan wulu (ꦶ) kanggo buku',
        'Pepet (ꦼ) kanggo Siti, lan suku (ꦸ) kanggo buku',
        'Suku (ꦸ) kanggo Siti, lan taling (ꦺ) kanggo buku',
      ],
      correctIndex: 0,
      explanation:
          'Vokal "i" ing tembung Siti mbutuhake sandhangan wulu (ꦶ), dene vokal "u" ing tembung buku nggunakake sandhangan suku (ꦸ).',
      sourceReference: 'Wewaton Panulise Aksara Jawa 1996',
    ),
    QuizQuestion(
      id: 'u3_n30_q05',
      topicKey: 'evaluasi_unit3',
      difficulty: QuizDifficulty.sangatMahir,
      type: QuestionType.glyphIdentify,
      prompt:
          '[Evaluasi U3] Nalika nulis ukara "Bapak tindak pasar", aksara Jawa kang mbutuhake pasangan aksara yaiku aksara...',
      glyph: '',
      options: [
        'Aksara Pa amarga sawise aksara Ka sigeg (mati) ing tindak',
        'Aksara Ta amarga aksara Ba ing tembung bapak sigeg mati',
        'Aksara Ka amarga tembung tindak mbutuhake aksara legena',
        'Aksara Sa amarga tembung pasar mbutuhake sandhangan layar',
      ],
      correctIndex: 0,
      explanation:
          'Ing tembung "tindak pasar", aksara Ka ing pungkasan tembung "tindak" sigeg (mati), mula aksara Pa ing tembung "pasar" kudu ditulis nganggo wujud Pasangan Pa (꧀ꦥ).',
      sourceReference: 'Pedoman Pasang Aksara Jawa SKB Tiga Gubernur',
    ),
    QuizQuestion(
      id: 'u3_n30_q06',
      topicKey: 'evaluasi_unit3',
      difficulty: QuizDifficulty.mahir,
      type: QuestionType.glyphIdentify,
      prompt: '[Evaluasi U3] Sandhangan cakra (ꦿ) gunane nambah seselan apa?',
      glyph: '',
      options: ['Seselan -ra-', 'Seselan -ya-', 'Seselan -la-', 'Seselan -wa-'],
      correctIndex: 0,
      explanation: 'Cakra nambah seselan "ra" ing wanda.',
      sourceReference: 'Evaluasi Unit 3 JawaLoka',
    ),
    QuizQuestion(
      id: 'u3_n30_q07',
      topicKey: 'evaluasi_unit3',
      difficulty: QuizDifficulty.mahir,
      type: QuestionType.glyphIdentify,
      prompt: '[Evaluasi U3] Pasangan aksara Jawa cacahe ana pira?',
      glyph: '',
      options: ['18', '20', '24', '15'],
      correctIndex: 1,
      explanation: 'Pasangan aksara cacahe ana 20.',
      sourceReference: 'Evaluasi Unit 3 JawaLoka',
    ),
    QuizQuestion(
      id: 'u3_n30_q08',
      topicKey: 'evaluasi_unit3',
      difficulty: QuizDifficulty.sangatMahir,
      type: QuestionType.glyphIdentify,
      prompt:
          '[Evaluasi U3] Pasangan kang manggon sejajar ing sisihe aksara yaiku...',
      glyph: '',
      options: ['Ha, Sa, Pa', 'Na, Ca, Ra', 'Ka, Da, Ta', 'Ma, Ga, Ba'],
      correctIndex: 0,
      explanation: 'Pasangan sejajar yaiku pasangan Ha, Sa, lan Pa.',
      sourceReference: 'Evaluasi Unit 3 JawaLoka',
    ),
    QuizQuestion(
      id: 'u3_n30_q09',
      topicKey: 'evaluasi_unit3',
      difficulty: QuizDifficulty.sangatMahir,
      type: QuestionType.glyphIdentify,
      prompt:
          '[Evaluasi U3] Swara "re" pepet yen dadi suku kata mandhiri kudu ditulis...',
      glyph: '',
      options: [
        'Ra kawuwuhan pepet',
        'Pa cerek (ꦉ)',
        'Nga lelet',
        'Cakra keret',
      ],
      correctIndex: 1,
      explanation: 'Swara re pepet mandhiri kudu ditulis Pa cerek (ꦉ).',
      sourceReference: 'Evaluasi Unit 3 JawaLoka',
    ),
    QuizQuestion(
      id: 'u3_n30_q10',
      topicKey: 'evaluasi_unit3',
      difficulty: QuizDifficulty.sangatMahir,
      type: QuestionType.glyphIdentify,
      prompt: '[Evaluasi U3] Tembung ꦥꦱꦂ wacane yaiku...',
      glyph: '',
      options: ['Pasa', 'Pasir', 'Pasar', 'Pari'],
      correctIndex: 2,
      explanation: 'ꦥꦱꦂ diwaca "Pasar".',
      sourceReference: 'Evaluasi Unit 3 JawaLoka',
    ),
  ];
}

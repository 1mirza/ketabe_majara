import 'package:flutter/material.dart';
import 'dart:ui';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'dart:math';

// --- شروع اپلیکیشن ---
// نکته: برای اجرای صحیح این کد، کتابخانه shared_preferences را به فایل pubspec.yaml اضافه کنید:
// dependencies:
//   shared_preferences: ^2.0.15

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = await SharedPreferences.getInstance();
  final avatarData = prefs.getString('user_avatar');

  runApp(InteractiveStoryApp(avatarData: avatarData));
}

// --- مدل‌های داده ---

class Avatar {
  final bool isBoy;
  final Color shirtColor;

  Avatar({required this.isBoy, required this.shirtColor});

  // توابع برای ذخیره و بازیابی اطلاعات آواتار
  Map<String, dynamic> toJson() => {
        'isBoy': isBoy,
        'shirtColor': shirtColor.value,
      };

  factory Avatar.fromJson(Map<String, dynamic> json) => Avatar(
        isBoy: json['isBoy'],
        shirtColor: Color(json['shirtColor']),
      );
}

class Choice {
  final String text;
  final int nextPage;
  final String? achievementKey;
  final bool isSuccess;

  const Choice({
    required this.text,
    required this.nextPage,
    this.achievementKey,
    this.isSuccess = false,
  });
}

class StoryPage {
  final String image;
  final String text;
  final List<Choice> choices;

  const StoryPage({
    required this.image,
    required this.text,
    required this.choices,
  });
}

class Story {
  final String id;
  final String title;
  final String description;
  final IconData icon;
  final List<Color> gradientColors;
  final Map<String, String> achievements;
  final List<StoryPage> pages;
  final int requiredStars;

  const Story({
    required this.id,
    required this.title,
    required this.description,
    required this.icon,
    required this.gradientColors,
    required this.achievements,
    required this.pages,
    this.requiredStars = 0,
  });
}

class Emotion {
  final String name;
  final String description;
  final IconData icon;
  final Color color;

  const Emotion(
      {required this.name,
      required this.description,
      required this.icon,
      required this.color});
}

// --- مخزن داده‌ها ---

final List<Emotion> emotions = [
  const Emotion(
      name: 'شادی',
      description:
          'وقتی احساس سبکی و خوشحالی می‌کنیم. مثل وقت‌هایی که بازی می‌کنیم یا دوستمان را می‌بینیم.',
      icon: Icons.sentiment_very_satisfied,
      color: Colors.amber),
  const Emotion(
      name: 'غم',
      description:
          'وقتی چیزی را از دست می‌دهیم یا دلمان برای کسی تنگ می‌شود. گریه کردن موقع غم اشکالی ندارد.',
      icon: Icons.sentiment_very_dissatisfied,
      color: Colors.blue),
  const Emotion(
      name: 'خشم',
      description:
          'وقتی حس می‌کنیم حق ما خورده شده یا چیزی برخلاف میل ماست. مهم است که خشم خود را درست نشان دهیم.',
      icon: Icons.sentiment_very_dissatisfied,
      color: Colors.red),
  const Emotion(
      name: 'ترس',
      description:
          'وقتی احساس خطر می‌کنیم. ترس به ما کمک می‌کند تا از خودمان مراقبت کنیم.',
      icon: Icons.masks,
      color: Colors.purple),
  const Emotion(
      name: 'تعجب',
      description:
          'وقتی با یک چیز غیرمنتظره روبرو می‌شویم. مثل دیدن یک هدیه ناگهانی!',
      icon: Icons.sentiment_neutral,
      color: Colors.green),
];

final List<Story> stories = [
  // داستان ۱: خوراکی گمشده
  const Story(
      id: "snackStory",
      title: "ماجرای خوراکی گمشده",
      description: "یک داستان درباره سوءتفاهم و شجاعت صحبت کردن.",
      icon: Icons.bakery_dining,
      gradientColors: [const Color(0xFF5B86E5), const Color(0xFF36D1DC)],
      requiredStars: 0,
      achievements: {
        "AGGRESSIVE_LESSON":
            "یاد گرفتم که عصبانیت معمولاً همه چیز را بدتر می‌کند.",
        "PASSIVE_LESSON": "یاد گرفتم که وقتی حرفی نزنم، مشکلم حل نمی‌شود.",
        "ASSERTIVE_ACHIEVEMENT":
            "آفرین! با صحبت کردن آرام، خیلی از مشکلات حل می‌شود!"
      },
      pages: [
        const StoryPage(
            image: "",
            text:
                "زنگ تفریح است. تو خیلی خوشحالی چون خوشمزه‌ترین خوراکی دنیا را آورده‌ای! کیفت را باز می‌کنی...",
            choices: [Choice(text: "بعدی", nextPage: 1)]),
        const StoryPage(
            image: "",
            text:
                "...اما خوراکی سر جایش نیست! ناگهان چشمت به سامان می‌افتد که در گوشه حیاط، دقیقاً همان خوراکی را می‌خورد.",
            choices: [
              Choice(text: "با عصبانیت داد می‌زنم: 'دزد!'", nextPage: 2),
              Choice(text: "ناراحت می‌شوم و یک گوشه می‌نشینم.", nextPage: 3),
              Choice(text: "با آرامش به سمتش می‌روم.", nextPage: 4)
            ]),
        const StoryPage(
            image: "",
            text:
                "سامان از داد تو می‌ترسد و عصبانی می‌شود. ناظم مدرسه هر دوی شما را به دفتر می‌برد و زنگ تفریحت را از دست می‌دهی.",
            choices: [
              Choice(
                  text: "پایان داستان",
                  nextPage: -1,
                  achievementKey: "AGGRESSIVE_LESSON")
            ]),
        const StoryPage(
            image: "",
            text:
                "تو تمام زنگ تفریح را تنها و غمگین بودی. هنوز هم نمی‌دانی خوراکی‌ات کجا رفته و گرسنه ماندی.",
            choices: [
              Choice(
                  text: "پایان داستان",
                  nextPage: -1,
                  achievementKey: "PASSIVE_LESSON")
            ]),
        const StoryPage(
            image: "",
            text:
                "کنارش می‌ایستی و می‌گویی: 'سلام سامان، من هم دقیقاً یک همچین خوراکی‌ای داشتم که گمشده. این مال توئه؟'",
            choices: [Choice(text: "ادامه...", nextPage: 5)]),
        const StoryPage(
            image: "",
            text:
                "سامان می‌گوید: 'وای! ببخشید! فکر کردم این مال منه.' او نصف خوراکی‌اش را به تو می‌دهد و با هم دوست می‌شوید!",
            choices: [
              Choice(
                  text: "پایان داستان",
                  nextPage: -1,
                  achievementKey: "ASSERTIVE_ACHIEVEMENT",
                  isSuccess: true)
            ]),
      ]),
  // داستان ۲: راز نقاشی خط‌خطی
  const Story(
    id: "scribbledDrawing",
    title: "راز نقاشی خط‌خطی",
    description: "وقتی کسی به وسایل ما آسیب می‌زند چه کار کنیم؟",
    icon: Icons.palette,
    gradientColors: [const Color(0xFFC33764), const Color(0xFF1D2671)],
    requiredStars: 0,
    achievements: {
      "REVENGE": "فهمیدم که انتقام گرفتن، حال خودم را هم بدتر می‌کند.",
      "SADNESS": "یاد گرفتم که پنهان کردن ناراحتی، کمکی به حل مشکل نمی‌کند.",
      "UNDERSTANDING":
          "آفرین! گاهی با پرسیدن دلیل کارها، می‌توانیم یک دوست جدید پیدا کنیم."
    },
    pages: [
      const StoryPage(
          image: "",
          text:
              "در کلاس هنر، بهترین نقاشی عمرت را کشیده‌ای! برای چند لحظه از کلاس بیرون می‌روی...",
          choices: [Choice(text: "بعدی", nextPage: 1)]),
      const StoryPage(
          image: "",
          text:
              "...وقتی برمی‌گردی، می‌بینی رضا بالای سر نقاشی تو ایستاده و یک خط بزرگ روی آن کشیده است!",
          choices: [
            Choice(text: "من هم نقاشی او را خط می‌زنم!", nextPage: 2),
            Choice(text: "بغض می‌کنم و به معلم چیزی نمی‌گویم.", nextPage: 3),
            Choice(
                text: "با ناراحتی می‌پرسم: 'چرا این کار رو کردی؟'",
                nextPage: 4),
          ]),
      const StoryPage(
          image: "",
          text:
              "تو هم نقاشی رضا را خط می‌کشی. هر دو عصبانی می‌شوید و معلم از هر دوی شما ناراحت می‌شود.",
          choices: [
            Choice(
                text: "پایان داستان", nextPage: -1, achievementKey: "REVENGE")
          ]),
      const StoryPage(
          image: "",
          text:
              "تو تمام روز ناراحت بودی و رضا هم نفهمید که چقدر کارش اشتباه بوده است.",
          choices: [
            Choice(
                text: "پایان داستان", nextPage: -1, achievementKey: "SADNESS")
          ]),
      const StoryPage(
          image: "",
          text:
              "رضا با شرمندگی می‌گوید: 'نقاشی تو خیلی قشنگ شده بود، منم دلم می‌خواست مثل تو نقاشی بکشم.'",
          choices: [Choice(text: "ادامه...", nextPage: 5)]),
      const StoryPage(
          image: "",
          text:
              "تو به رضا پیشنهاد می‌دهی که با هم یک نقاشی جدید و بزرگتر بکشید. هر دو خوشحال می‌شوید!",
          choices: [
            Choice(
                text: "پایان داستان",
                nextPage: -1,
                achievementKey: "UNDERSTANDING",
                isSuccess: true)
          ]),
    ],
  ),
  // داستان ۳: گروه گل کوچیک
  const Story(
      id: "soccerGame",
      title: "گروه گل کوچیک",
      description: "داستانی درباره طرد شدن و پیدا کردن راه‌های جدید برای شادی.",
      icon: Icons.sports_soccer,
      gradientColors: [const Color(0xFF136a8a), const Color(0xFF267871)],
      requiredStars: 1,
      achievements: {
        "FORCE":
            "یاد گرفتم که با زور نمی‌توانم کسی را مجبور به بازی با خودم کنم.",
        "WAITING": "فهمیدم که منتظر ماندن برای دیگران، همیشه بهترین راه نیست.",
        "CREATIVITY": "آفرین! گاهی بهترین بازی‌ها را خودمان شروع می‌کنیم!"
      },
      pages: [
        const StoryPage(
            image: "",
            text:
                "در حیاط مدرسه، چند نفر از بچه‌ها دارند گل کوچیک بازی می‌کنند. تو هم عاشق فوتبال هستی!",
            choices: [Choice(text: "بعدی", nextPage: 1)]),
        const StoryPage(
            image: "",
            text:
                "جلو می‌روی و می‌پرسی: 'میشه منم بازی کنم؟' یکی از بچه‌ها می‌گوید: 'نه، تیم ما کامله!'",
            choices: [
              Choice(text: "با توپ می‌پرم وسط بازیشون!", nextPage: 2),
              Choice(text: "کنار می‌ایستم تا بازیشان تمام شود.", nextPage: 3),
              Choice(
                  text: "یک توپ دیگر برمی‌دارم و خودم تمرین می‌کنم.",
                  nextPage: 4)
            ]),
        const StoryPage(
            image: "",
            text:
                "بچه‌ها از اینکه بازیشان را خراب کردی عصبانی می‌شوند و دیگر هیچ‌کس بازی نمی‌کند.",
            choices: [
              Choice(
                  text: "پایان داستان", nextPage: -1, achievementKey: "FORCE")
            ]),
        const StoryPage(
            image: "",
            text:
                "تو تمام زنگ تفریح منتظر ماندی، اما بازی آن‌ها هیچوقت تمام نشد و تو بازی نکردی.",
            choices: [
              Choice(
                  text: "پایان داستان", nextPage: -1, achievementKey: "WAITING")
            ]),
        const StoryPage(
            image: "",
            text:
                "شروع می‌کنی به روپایی زدن. مریم که او هم بازی نکرده بود، تو را می‌بیند و به سمتت می‌آید.",
            choices: [Choice(text: "ادامه...", nextPage: 5)]),
        const StoryPage(
            image: "",
            text:
                "مریم می‌گوید: 'عالیه! بیا با هم مسابقه روپایی بزنیم!' شما یک بازی جدید و هیجان‌انگیزتر را شروع می‌کنید.",
            choices: [
              Choice(
                  text: "پایان داستان",
                  nextPage: -1,
                  achievementKey: "CREATIVITY",
                  isSuccess: true)
            ]),
      ]),
  // داستان ۴: پیامک عجیب
  const Story(
      id: "cyberBullying",
      title: "پیامک عجیب",
      description: "چطور در دنیای مجازی از خودمان و دوستانمان مراقبت کنیم؟",
      icon: Icons.chat,
      gradientColors: [const Color(0xFF005AA7), const Color(0xFFFFFDE4)],
      requiredStars: 1,
      achievements: {
        "FIGHT":
            "یاد گرفتم که دعوا در گروه‌های مجازی، فقط اوضاع را بدتر می‌کند.",
        "LEAVE":
            "فهمیدم که ترک کردن گروه، مشکل اصلی را حل نمی‌کند و احساساتم را پنهان می‌کند.",
        "PRIVATE_TALK":
            "آفرین! صحبت خصوصی و محترمانه بهترین راه برای حل مشکلات مجازی است."
      },
      pages: [
        const StoryPage(
            image: "",
            text:
                "در گروه کلاسی، عکسی از خودت در مسابقه ورزشی گذاشته‌ای. ناگهان سارا یک شکلک خنده برای عکست می‌فرستد.",
            choices: [
              Choice(text: "جوابش را با یک شکلک عصبانی می‌دهم.", nextPage: 1),
              Choice(text: "از گروه خارج می‌شوم.", nextPage: 2),
              Choice(text: "به صورت خصوصی به سارا پیام می‌دهم.", nextPage: 3),
            ]),
        const StoryPage(
            image: "",
            text:
                "بحث بین شما در گروه بالا می‌گیرد و بقیه بچه‌ها هم وارد ماجرا می‌شوند. معلم مجبور می‌شود گروه را ببندد.",
            choices: [
              Choice(
                  text: "پایان داستان", nextPage: -1, achievementKey: "FIGHT")
            ]),
        const StoryPage(
            image: "",
            text:
                "تو از گروه بیرون می‌روی ولی سارا و بقیه بچه‌ها دلیلش را نمی‌فهمند و تو همچنان ناراحت هستی.",
            choices: [
              Choice(
                  text: "پایان داستان", nextPage: -1, achievementKey: "LEAVE")
            ]),
        const StoryPage(
            image: "",
            text:
                "به سارا پیام می‌دهی: 'سلام سارا، وقتی اون شکلک رو فرستادی من ناراحت شدم.'",
            choices: [Choice(text: "ادامه...", nextPage: 4)]),
        const StoryPage(
            image: "",
            text:
                "سارا جواب می‌دهد: 'واقعا ببخشید! منظور بدی نداشتم. فکر کردم شوخیه. الان پاکش می‌کنم.'",
            choices: [
              Choice(
                  text: "پایان داستان",
                  nextPage: -1,
                  achievementKey: "PRIVATE_TALK",
                  isSuccess: true)
            ]),
      ]),
  // داستان ۵: فشار دوستان
  const Story(
      id: "peerPressure",
      title: "فشار دوستان",
      description: "چطور به چیزی که دوست نداریم 'نه' بگوییم؟",
      icon: Icons.people,
      gradientColors: [const Color(0xFFF7971E), const Color(0xFFFFD200)],
      requiredStars: 2,
      achievements: {
        "JOINING_IN":
            "فهمیدم که همراهی با کارهای اشتباه، من را هم مقصر می‌کند.",
        "SILENCE": "یاد گرفتم که سکوت در برابر کار اشتباه، به معنی موافقت است.",
        "SAYING_NO": "آفرین! 'نه' گفتن به کار اشتباه، نشانه شجاعت و قدرت است."
      },
      pages: [
        const StoryPage(
            image: "",
            text:
                "زنگ آخر است. علی به تو و چند نفر دیگر می‌گوید: 'بیاین کیف سینا رو قایم کنیم، بخندیم!'",
            choices: [
              Choice(text: "باشه، فکر خوبیه! منم هستم!", nextPage: 1),
              Choice(text: "نمیدونم... شاید کار درستی نباشه.", nextPage: 2),
              Choice(
                  text: "نه بچه‌ها، این کار اذیت کردنه. من نیستم.",
                  nextPage: 3),
            ]),
        const StoryPage(
            image: "",
            text:
                "شما کیف سینا را قایم می‌کنید. سینا خیلی ناراحت و نگران می‌شود و معلم شما را دعوا می‌کند.",
            choices: [
              Choice(
                  text: "پایان داستان",
                  nextPage: -1,
                  achievementKey: "JOINING_IN")
            ]),
        const StoryPage(
            image: "",
            text:
                "تو کاری نمی‌کنی، اما بچه‌ها کیف را قایم می‌کنند. تو هم به اندازه آنها در ناراحت کردن سینا مقصر بودی.",
            choices: [
              Choice(
                  text: "پایان داستان", nextPage: -1, achievementKey: "SILENCE")
            ]),
        const StoryPage(
            image: "",
            text:
                "وقتی تو 'نه' می‌گویی، یکی دیگر از بچه‌ها هم جرأت پیدا می‌کند و می‌گوید: 'منم نیستم.' علی از کارش پشیمان می‌شود.",
            choices: [
              Choice(
                  text: "پایان داستان",
                  nextPage: -1,
                  achievementKey: "SAYING_NO",
                  isSuccess: true)
            ]),
      ]),
  // داستان ۶: تعارف لواشک
  const Story(
      id: "politeDecline",
      title: "تعارف لواشک",
      description: "چطور مودبانه چیزی را رد کنیم؟",
      icon: Icons.no_food,
      gradientColors: [const Color(0xFFE55D87), const Color(0xFF5FC3E4)],
      requiredStars: 2,
      achievements: {
        "RUDE": "فهمیدم که تند حرف زدن، ممکن است دوستانم را ناراحت کند.",
        "RELUCTANT":
            "یاد گرفتم لازم نیست برای خوشحال کردن دیگران، کاری که دوست ندارم را انجام دهم.",
        "POLITE_NO":
            "آفرین! می‌توانم مودبانه و بدون ناراحت کردن دیگران، تعارفشان را رد کنم."
      },
      pages: [
        const StoryPage(
            image: "",
            text:
                "ندا یک لواشک خیلی ترش به تو تعارف می‌کند، اما تو اصلاً خوراکی ترش دوست نداری.",
            choices: [
              Choice(
                  text: "می‌گویم: 'اه، نه! من از اینا خوشم نمیاد.'",
                  nextPage: 1),
              Choice(text: "با اکراه می‌گیرم و می‌خورم.", nextPage: 2),
              Choice(
                  text: "می‌گویم: 'ممنونم ندا جون، ولی من میل ندارم.'",
                  nextPage: 3),
            ]),
        const StoryPage(
            image: "",
            text:
                "ندا از طرز حرف زدن تو خیلی دلخور می‌شود و دیگر به تو چیزی تعارف نمی‌کند.",
            choices: [
              Choice(text: "پایان داستان", nextPage: -1, achievementKey: "RUDE")
            ]),
        const StoryPage(
            image: "",
            text:
                "لواشک را می‌خوری اما از ترشی آن صورتت در هم می‌رود. نه تو لذت بردی و نه ندا خوشحال شد.",
            choices: [
              Choice(
                  text: "پایان داستان",
                  nextPage: -1,
                  achievementKey: "RELUCTANT")
            ]),
        const StoryPage(
            image: "",
            text:
                "ندا لبخند می‌زند و می‌گوید: 'باشه عزیزم، هر طور راحتی.' دوستی شما مثل قبل باقی می‌ماند.",
            choices: [
              Choice(
                  text: "پایان داستان",
                  nextPage: -1,
                  achievementKey: "POLITE_NO",
                  isSuccess: true)
            ]),
      ]),
  // داستان ۷: وقتی همه خندیدند
  const Story(
      id: "laughingClass",
      title: "وقتی همه خندیدند",
      description: "داستانی درباره زمین خوردن و دوباره بلند شدن.",
      icon: Icons.sentiment_very_dissatisfied,
      gradientColors: [const Color(0xFFF09819), const Color(0xFFEDDE5D)],
      requiredStars: 3,
      achievements: {
        "ANGER":
            "فهمیدم که عصبانی شدن از خنده دیگران، فقط توجه‌ها را بیشتر می‌کند.",
        "SHAME":
            "یاد گرفتم که اشتباه کردن ترسناک نیست و نباید باعث شود ساکت بمانم.",
        "RESILIENCE":
            "آفرین! همه اشتباه می‌کنند. مهم این است که دوباره تلاش کنیم."
      },
      pages: [
        const StoryPage(
            image: "",
            text:
                "معلم از تو یک سوال می‌پرسد و تو یک جواب اشتباه می‌دهی. چند نفر در کلاس می‌خندند.",
            choices: [
              Choice(text: "داد می‌زنم: 'به چی می‌خندین؟!'", nextPage: 1),
              Choice(
                  text: "سرم را پایین می‌اندازم و سکوت می‌کنم.", nextPage: 2),
              Choice(text: "لبخند می‌زنم و دوباره تلاش می‌کنم.", nextPage: 3),
            ]),
        const StoryPage(
            image: "",
            text:
                "با داد زدن تو، کل کلاس ساکت می‌شود و به تو نگاه می‌کند. معلم از رفتارت ناراحت می‌شود.",
            choices: [
              Choice(
                  text: "پایان داستان", nextPage: -1, achievementKey: "ANGER")
            ]),
        const StoryPage(
            image: "",
            text:
                "تو تا آخر کلاس دیگر حرفی نمی‌زنی و فرصت یاد گرفتن جواب درست را از دست می‌دهی.",
            choices: [
              Choice(
                  text: "پایان داستان", nextPage: -1, achievementKey: "SHAME")
            ]),
        const StoryPage(
            image: "",
            text:
                "تو با اعتماد به نفس به معلم می‌گویی: 'ببخشید، اشتباه کردم.' معلم لبخند می‌زند و جوابت را تصحیح می‌کند.",
            choices: [
              Choice(
                  text: "پایان داستان",
                  nextPage: -1,
                  achievementKey: "RESILIENCE",
                  isSuccess: true)
            ]),
      ]),
  // داستان ۸: یک دوست جدید
  const Story(
      id: "newFriend",
      title: "یک دوست جدید",
      description: "چطور می‌توانیم باعث شویم دیگران احساس تنهایی نکنند؟",
      icon: Icons.emoji_emotions,
      gradientColors: [const Color(0xFF1c92d2), const Color(0xFFf2fcfe)],
      requiredStars: 3,
      achievements: {
        "INDIFFERENCE": "از دست دادن فرصت پیدا کردن یک دوست جدید.",
        "SHYNESS":
            "یاد گرفتم که گاهی باید بر خجالتم غلبه کنم تا اتفاقات خوب بیفتد.",
        "FRIENDLINESS":
            "آفرین! شروع کردن یک دوستی، یکی از بهترین کارهای دنیاست."
      },
      pages: [
        const StoryPage(
            image: "",
            text:
                "یک دانش‌آموز جدید به نام پارسا به کلاستان آمده و در حیاط تنها نشسته است.",
            choices: [
              Choice(
                  text: "نادیده‌اش می‌گیرم و با دوستانم بازی می‌کنم.",
                  nextPage: 1),
              Choice(
                  text: "دلم می‌خواهد با او صحبت کنم ولی خجالت می‌کشم.",
                  nextPage: 2),
              Choice(text: "میرم پیشش و خودم را معرفی می‌کنم.", nextPage: 3),
            ]),
        const StoryPage(
            image: "",
            text: "تو تمام زنگ تفریح را بازی کردی، اما پارسا همچنان تنها ماند.",
            choices: [
              Choice(
                  text: "پایان داستان",
                  nextPage: -1,
                  achievementKey: "INDIFFERENCE")
            ]),
        const StoryPage(
            image: "",
            text:
                "تو فقط از دور نگاه کردی و زنگ خورد. فرصت حرف زدن با پارسا را از دست دادی.",
            choices: [
              Choice(
                  text: "پایان داستان", nextPage: -1, achievementKey: "SHYNESS")
            ]),
        const StoryPage(
            image: "",
            text:
                "پارسا از دیدن تو خوشحال می‌شود. شما شروع به صحبت می‌کنید و می‌فهمید که هر دو به یک بازی علاقه دارید!",
            choices: [
              Choice(
                  text: "پایان داستان",
                  nextPage: -1,
                  achievementKey: "FRIENDLINESS",
                  isSuccess: true)
            ]),
      ]),
  // داستان ۹: شایعه در حیاط
  const Story(
      id: "rumor",
      title: "شایعه در حیاط",
      description: "وقتی یک حرف دروغ درباره دوستمان می‌شنویم.",
      icon: Icons.record_voice_over,
      gradientColors: [const Color(0xFFcc2b5e), const Color(0xFF753a88)],
      requiredStars: 4,
      achievements: {
        "SPREADING": "فهمیدم که پخش کردن شایعه، به دوستانم آسیب می‌زند.",
        "DOUBT":
            "یاد گرفتم نباید به راحتی حرف‌های دیگران را درباره دوستانم باور کنم.",
        "LOYALTY":
            "آفرین! دفاع از دوستان و اعتماد به آنها، نشانه یک دوستی واقعی است."
      },
      pages: [
        const StoryPage(
            image: "",
            text:
                "یکی از همکلاسی‌هایت پیش تو می‌آید و یک حرف بد در مورد بهترین دوستت، امیر، به تو می‌زند.",
            choices: [
              Choice(text: "با تعجب به بقیه هم تعریف می‌کنم!", nextPage: 1),
              Choice(text: "باور می‌کنم و از امیر دلخور می‌شوم.", nextPage: 2),
              Choice(
                  text: "می‌گویم: 'امیر دوست منه و من باور نمی‌کنم.'",
                  nextPage: 3),
            ]),
        const StoryPage(
            image: "",
            text:
                "شایعه در مدرسه پخش می‌شود و امیر از اینکه تو حرف آنها را باور کردی، خیلی ناراحت می‌شود.",
            choices: [
              Choice(
                  text: "پایان داستان",
                  nextPage: -1,
                  achievementKey: "SPREADING")
            ]),
        const StoryPage(
            image: "",
            text:
                "تو بدون اینکه از امیر سوال کنی، از او فاصله می‌گیری و دوستی شما به خطر می‌افتد.",
            choices: [
              Choice(
                  text: "پایان داستان", nextPage: -1, achievementKey: "DOUBT")
            ]),
        const StoryPage(
            image: "",
            text:
                "تو پیش امیر می‌روی و ماجرا را برایش تعریف می‌کنی. امیر از اینکه به او اعتماد کردی خوشحال می‌شود و دوستی‌تان قوی‌تر می‌شود.",
            choices: [
              Choice(
                  text: "پایان داستان",
                  nextPage: -1,
                  achievementKey: "LOYALTY",
                  isSuccess: true)
            ]),
      ]),
  // داستان ۱۰: مسئولیت اشتباه من
  Story(
      id: "mistake",
      title: "مسئولیت اشتباه من",
      description: "داستانی درباره اهمیت راستگویی و شجاعت.",
      icon: Icons.gavel,
      gradientColors: [const Color(0xFF373B44), const Color(0xFF4286f4)],
      requiredStars: 4,
      achievements: {
        "HIDING": "فهمیدم که فرار از اشتباه، فقط حال آدم را بدتر می‌کند.",
        "BLAMING":
            "یاد گرفتم که انداختن تقصیر گردن دیگران، کار بسیار اشتباهی است.",
        "HONESTY":
            "آفرین! به عهده گرفتن مسئولیت اشتباه، نشانه شجاعت و بزرگی است."
      },
      pages: [
        const StoryPage(
            image: "",
            text:
                "در حیاط، توپت به گلدان آقای احمدی، سرایدار مدرسه، می‌خورد و آن را می‌شکند. هیچکس تو را ندیده.",
            choices: [
              Choice(text: "سریع فرار می‌کنم!", nextPage: 1),
              Choice(text: "می‌گویم کار بچه‌های دیگر بوده.", nextPage: 2),
              Choice(
                  text: "می‌روم و به آقای احمدی حقیقت را می‌گویم.",
                  nextPage: 3),
            ]),
        const StoryPage(
            image: "",
            text:
                "تو فرار می‌کنی، اما تمام روز عذاب وجدان داری و از دیدن آقای احمدی خجالت می‌کشی.",
            choices: [
              Choice(
                  text: "پایان داستان", nextPage: -1, achievementKey: "HIDING")
            ]),
        const StoryPage(
            image: "",
            text:
                "آقای احمدی می‌فهمد که تو دروغ گفته‌ای و از تو خیلی بیشتر ناراحت می‌شود.",
            choices: [
              Choice(
                  text: "پایان داستان", nextPage: -1, achievementKey: "BLAMING")
            ]),
        const StoryPage(
            image: "",
            text:
                "آقای احمدی از راستگویی تو خوشحال می‌شود و می‌گوید: 'اشکالی نداره پسرم، مهم اینه که شجاع بودی و حقیقت رو گفتی.'",
            choices: [
              Choice(
                  text: "پایان داستان",
                  nextPage: -1,
                  achievementKey: "HONESTY",
                  isSuccess: true)
            ]),
      ]),
  // داستان ۱۱: کلاسور قرضی
  Story(
      id: "borrowedBinder",
      title: "کلاسور قرضی",
      description: "وقتی به وسایل دیگران آسیب می‌زنیم چه کار کنیم؟",
      icon: Icons.book_outlined,
      gradientColors: [const Color(0xFFfd746c), const Color(0xFFff9068)],
      requiredStars: 5,
      achievements: {
        "LIE": "فهمیدم که دروغ گفتن، اوضاع را پیچیده‌تر و بدتر می‌کند.",
        "HIDE":
            "یاد گرفتم که پنهان کردن اشتباه، مشکل را حل نمی‌کند و بی‌احترامی است.",
        "RESPONSIBILITY":
            "آفرین! قبول کردن مسئولیت اشتباه و جبران آن، کار درستی است."
      },
      pages: [
        const StoryPage(
            image: "",
            text:
                "کلاسور دوستت، سمیرا، را قرض گرفته‌ای تا جزوه‌هایش را بنویسی. ناگهان لیوان آبت روی آن می‌ریزد!",
            choices: [
              Choice(
                  text: "کلاسور را خشک می‌کنم و به رویم نمی‌آورم.",
                  nextPage: 1),
              Choice(text: "به سمیرا می‌گویم خودش خراب بوده.", nextPage: 2),
              Choice(text: "حقیقت را می‌گویم و عذرخواهی می‌کنم.", nextPage: 3),
            ]),
        const StoryPage(
            image: "",
            text:
                "سمیرا وقتی کلاسور لک شده را می‌بیند، خیلی ناراحت می‌شود و دیگر به تو اعتماد نمی‌کند.",
            choices: [
              Choice(text: "پایان داستان", nextPage: -1, achievementKey: "HIDE")
            ]),
        const StoryPage(
            image: "",
            text:
                "سمیرا می‌داند که تو دروغ می‌گویی و از اینکه به او تهمت زده‌ای، دوستی‌اش را با تو تمام می‌کند.",
            choices: [
              Choice(text: "پایان داستان", nextPage: -1, achievementKey: "LIE")
            ]),
        const StoryPage(
            image: "",
            text:
                "به سمیرا می‌گویی: 'واقعا متاسفم، حواسم نبود. اجازه بده یک کلاسور نو برایت بخرم.'",
            choices: [Choice(text: "ادامه...", nextPage: 4)]),
        const StoryPage(
            image: "",
            text:
                "سمیرا از صداقت تو خوشحال می‌شود و می‌گوید: 'مهم نیست، مهم اینه که راستش رو گفتی. دوستی ما مهم‌تره.'",
            choices: [
              Choice(
                  text: "پایان داستان",
                  nextPage: -1,
                  achievementKey: "RESPONSIBILITY",
                  isSuccess: true)
            ]),
      ]),
  // داستان ۱۲: برنده و بازنده
  Story(
      id: "winningLosing",
      title: "برنده و بازنده",
      description: "چطور در بازی‌ها رفتار درستی داشته باشیم؟",
      icon: Icons.flag_circle,
      gradientColors: [const Color(0xFF38ef7d), const Color(0xFF11998e)],
      requiredStars: 5,
      achievements: {
        "BRAGGING":
            "یاد گرفتم که فخرفروشی بعد از برد، دیگران را ناراحت می‌کند.",
        "SORE_LOSER":
            "فهمیدم که عصبانیت بعد از باخت، لذت بازی را از بین می‌برد.",
        "GOOD_SPORT": "آفرین! مهم لذت بردن از بازی است، نه فقط بردن یا باختن."
      },
      pages: [
        const StoryPage(
            image: "",
            text:
                "داری با دوستت منچ بازی می‌کни. در حرکت آخر، تاس می‌اندازی و می‌بری!",
            choices: [
              Choice(text: "فریاد می‌زنم: 'بردم! تو باختی!'", nextPage: 1),
              Choice(text: "بازی خوبی بود! دست می‌دهم.", nextPage: 2),
            ]),
        const StoryPage(
            image: "",
            text:
                "دوستت از رفتار تو ناراحت می‌شود و می‌گوید دیگر با تو بازی نمی‌کند.",
            choices: [
              Choice(
                  text: "پایان داستان",
                  nextPage: -1,
                  achievementKey: "BRAGGING")
            ]),
        const StoryPage(
            image: "",
            text:
                "دوستت از بازی جوانمردانه تو خوشحال می‌شود و پیشنهاد می‌دهد یک دست دیگر بازی کنید.",
            choices: [
              Choice(
                  text: "پایان داستان",
                  nextPage: -1,
                  achievementKey: "GOOD_SPORT",
                  isSuccess: true)
            ]),
        const StoryPage(
            image: "",
            text:
                "داری با دوستت منچ بازی می‌کنی. در حرکت آخر، دوستت تاس بهتری می‌آورد و می‌برد.",
            choices: [
              Choice(text: "با عصبانیت مهره‌ها را پرت می‌کنم.", nextPage: 4),
              Choice(text: "به او تبریک می‌گویم.", nextPage: 2)
            ]),
        const StoryPage(
            image: "",
            text: "بازی خراب می‌شود و دوستت از رفتار بچه‌گانه تو تعجب می‌کند.",
            choices: [
              Choice(
                  text: "پایان داستان",
                  nextPage: -1,
                  achievementKey: "SORE_LOSER")
            ]),
      ]),
  // داستان ۱۳: دعوت‌نامه گمشده
  Story(
      id: "missingInvitation",
      title: "دعوت‌نامه گمشده",
      description: "وقتی حس می‌کنیم نادیده گرفته شده‌ایم.",
      icon: Icons.mail_outline,
      gradientColors: [const Color(0xFFa8c0ff), const Color(0xFF3f2b96)],
      requiredStars: 6,
      achievements: {
        "ASSUMPTION":
            "یاد گرفتم که زود قضاوت نکنم و همیشه همه‌چیز آنطور که به نظر می‌رسد نیست.",
        "ISOLATION":
            "فهمیدم که فاصله گرفتن از دوستانم، فقط من را تنهاتر می‌کند.",
        "COMMUNICATION": "آفرین! صحبت کردن بهترین راه برای رفع سوءتفاهم‌ها است."
      },
      pages: [
        const StoryPage(
            image: "",
            text:
                "همه بچه‌ها در کلاس درباره جشن تولد نیما صحبت می‌کنند، اما تو هیچ کارت دعوتی نگرفته‌ای.",
            choices: [
              Choice(
                  text: "فکر می‌کنم نیما عمدا من را دعوت نکرده.", nextPage: 1),
              Choice(text: "از همه فاصله می‌گیرم.", nextPage: 2),
              Choice(text: "از خود نیما سوال می‌پرسم.", nextPage: 3),
            ]),
        const StoryPage(
            image: "",
            text:
                "از نیما دلخور می‌شوی، در حالی که شاید یک سوءتفاهم ساده پیش آمده باشد.",
            choices: [
              Choice(
                  text: "پایان داستان",
                  nextPage: -1,
                  achievementKey: "ASSUMPTION")
            ]),
        const StoryPage(
            image: "",
            text: "تو تنها می‌مانی و فرصت حل کردن ماجرا را از دست می‌دهی.",
            choices: [
              Choice(
                  text: "پایان داستان",
                  nextPage: -1,
                  achievementKey: "ISOLATION")
            ]),
        const StoryPage(
            image: "",
            text:
                "نیما می‌گوید: 'معلومه که دعوتت کردم! شاید کارتت تو کیفت گم شده.' کیفت را می‌گردی و کارت را پیدا می‌کni!",
            choices: [
              Choice(
                  text: "پایان داستان",
                  nextPage: -1,
                  achievementKey: "COMMUNICATION",
                  isSuccess: true)
            ]),
      ]),
  // داستان ۱۴: کار گروهی سخت
  Story(
      id: "groupProject",
      title: "کار گروهی سخت",
      description: "چطور با همکلاسی‌هایی که همکاری نمی‌کنند، کار کنیم؟",
      icon: Icons.groups,
      gradientColors: [const Color(0xFFfdfc47), const Color(0xFF24fe41)],
      requiredStars: 6,
      achievements: {
        "COMPLAIN": "یاد گرفتم که شکایت کردن اولین راه حل نیست.",
        "DO_IT_ALONE":
            "فهمیدم که انجام دادن همه کارها به تنهایی، منصفانه نیست.",
        "LEADERSHIP":
            "آفرین! با گفتگو و تقسیم وظایف، می‌توان یک گروه خوب را رهبری کرد."
      },
      pages: [
        const StoryPage(
            image: "",
            text:
                "معلم شما را برای یک کار گروهی سه نفره انتخاب کرده، اما هم‌گروهی‌ات، آرش، فقط بازیگوشی می‌کند.",
            choices: [
              Choice(text: "فورا به معلم شکایت می‌کنم.", nextPage: 1),
              Choice(text: "کار او را هم خودم انجام می‌دهم.", nextPage: 2),
              Choice(
                  text: "با آرش صحبت می‌کنم و یک وظیفه مشخص به او می‌دهم.",
                  nextPage: 3),
            ]),
        const StoryPage(
            image: "",
            text:
                "معلم از تو می‌خواهد که اول خودت سعی کنی مشکل را حل کنی. فرصت همکاری از دست می‌رود.",
            choices: [
              Choice(
                  text: "پایان داستان",
                  nextPage: -1,
                  achievementKey: "COMPLAIN")
            ]),
        const StoryPage(
            image: "",
            text:
                "تو خسته می‌شوی و آرش هم چیزی یاد نمی‌گیرد. این کار گروهی نبود.",
            choices: [
              Choice(
                  text: "پایان داستان",
                  nextPage: -1,
                  achievementKey: "DO_IT_ALONE")
            ]),
        const StoryPage(
            image: "",
            text:
                "آرش از اینکه به او یک کار مشخص داده‌ای خوشحال می‌شود و با علاقه آن را انجام می‌دهد. گروه شما موفق می‌شود!",
            choices: [
              Choice(
                  text: "پایان داستان",
                  nextPage: -1,
                  achievementKey: "LEADERSHIP",
                  isSuccess: true)
            ]),
      ]),
  // داستان ۱۵: شوخی یا مسخره بازی؟
  Story(
      id: "jokingVsTeasing",
      title: "شوخی یا مسخره بازی؟",
      description: "تفاوت بین شوخی دوستانه و اذیت کردن چیست؟",
      icon: Icons.tag_faces,
      gradientColors: [const Color(0xFF89f7fe), const Color(0xFF66a6ff)],
      requiredStars: 7,
      achievements: {
        "PRETEND":
            "یاد گرفتم که تظاهر به خوب بودن، به احساسات خودم آسیب می‌زند.",
        "INSULT_BACK":
            "فهمیدم که جواب دادن با توهین، فقط دعوا را بزرگتر می‌کند.",
        "SET_BOUNDARY": "آفرین! مشخص کردن حد و مرزها با احترام، نشانه قدرت است."
      },
      pages: [
        const StoryPage(
            image: "",
            text:
                "دوستت مدام با مدل موی جدیدت شوخی می‌کند. اول برایت خنده‌دار بود، اما دیگر نه.",
            choices: [
              Choice(text: "من هم الکی می‌خندم.", nextPage: 1),
              Choice(text: "من هم او را مسخره می‌کنم.", nextPage: 2),
              Choice(text: "به آرامی می‌گویم که دیگر ادامه ندهد.", nextPage: 3),
            ]),
        const StoryPage(
            image: "",
            text:
                "تو می‌خندی، اما درونت ناراحتی. دوستت هم نمی‌فهمد که کارش اشتباه است.",
            choices: [
              Choice(
                  text: "پایان داستان", nextPage: -1, achievementKey: "PRETEND")
            ]),
        const StoryPage(
            image: "",
            text: "دعوای شما بالا می‌گیرد و دوستی‌تان خراب می‌شود.",
            choices: [
              Choice(
                  text: "پایان داستان",
                  nextPage: -1,
                  achievementKey: "INSULT_BACK")
            ]),
        const StoryPage(
            image: "",
            text:
                "به دوستت می‌گویی: 'می‌دونم شوخی می‌کنی، ولی من ناراحت میشم. لطفاً دیگه نگو.' او عذرخواهی می‌کند.",
            choices: [
              Choice(
                  text: "پایان داستان",
                  nextPage: -1,
                  achievementKey: "SET_BOUNDARY",
                  isSuccess: true)
            ]),
      ]),
  // داستان ۱۶: پول پیدا شده
  Story(
      id: "foundMoney",
      title: "پول پیدا شده",
      description: "وقتی چیزی پیدا می‌کنیم که مال ما نیست.",
      icon: Icons.account_balance_wallet,
      gradientColors: [const Color(0xFFD4AF37), const Color(0xFFF7C46C)],
      requiredStars: 7,
      achievements: {
        "KEEPING_IT": "فهمیدم که برداشتن چیزی که مال من نیست، درست نیست.",
        "ASKING_FRIENDS": "یاد گرفتم که باید دنبال صاحب اصلی وسیله بگردم.",
        "INTEGRITY":
            "آفرین! درستکاری یعنی انجام کار صحیح، حتی وقتی کسی نمی‌بیند."
      },
      pages: [
        const StoryPage(
            image: "",
            text:
                "در راهرو مدرسه یک اسکناس ۱۰ هزار تومانی پیدا می‌کنی. هیچکس هم حواسش نیست.",
            choices: [
              Choice(text: "در جیبم می‌گذارم!", nextPage: 1),
              Choice(text: "از دوستان نزدیکم می‌پرسم مال آنهاست؟", nextPage: 2),
              Choice(text: "آن را به دفتر مدرسه تحویل می‌دهم.", nextPage: 3),
            ]),
        const StoryPage(
            image: "",
            text:
                "تو پول را برمی‌داری، اما تمام روز احساس بدی داری چون می‌دانی کار درستی نکرده‌ای.",
            choices: [
              Choice(
                  text: "پایان داستان",
                  nextPage: -1,
                  achievementKey: "KEEPING_IT")
            ]),
        const StoryPage(
            image: "",
            text:
                "ممکن است پول مال دوستانت نباشد و صاحب اصلی آن هیچوقت پیدا نشود.",
            choices: [
              Choice(
                  text: "پایان داستان",
                  nextPage: -1,
                  achievementKey: "ASKING_FRIENDS")
            ]),
        const StoryPage(
            image: "",
            text:
                "معاون مدرسه از تو تشکر می‌کند و بعداً صاحب پول پیدا می‌شود و از تو قدردانی می‌کند. تو احساس فوق‌العاده‌ای داری!",
            choices: [
              Choice(
                  text: "پایان داستان",
                  nextPage: -1,
                  achievementKey: "INTEGRITY",
                  isSuccess: true)
            ]),
      ]),
  // داستان ۱۷: مقایسه با دیگران
  Story(
      id: "comparison",
      title: "مقایسه با دیگران",
      description: "هر کسی توانایی‌های خودش را دارد.",
      icon: Icons.trending_up,
      gradientColors: [const Color(0xFFBCC6CC), const Color(0xFFEAEAEA)],
      requiredStars: 8,
      achievements: {
        "JEALOUSY": "یاد گرفتم که حسادت به دیگران، فقط حال خودم را بد می‌کند.",
        "SELF_DOUBT":
            "فهمیدم که نباید خودم را با دیگران مقایسه کنم، چون هرکدام از ما بی‌نظیریم.",
        "APPRECIATION":
            "آفرین! تشویق دیگران و تمرکز بر پیشرفت خودم، بهترین راه است."
      },
      pages: [
        const StoryPage(
            image: "",
            text:
                "همکلاسی‌ات، مریم، در امتحان ریاضی نمره کامل گرفته، اما نمره تو متوسط شده.",
            choices: [
              Choice(text: "با حسادت می‌گویم: 'شانس آوردی!'", nextPage: 1),
              Choice(text: "فکر می‌کنم من خنگ هستم.", nextPage: 2),
              Choice(text: "به مریم تبریک می‌گویم.", nextPage: 3),
            ]),
        const StoryPage(
            image: "",
            text: "مریم از حرف تو ناراحت می‌شود و تو هم احساس بدی پیدا می‌کنی.",
            choices: [
              Choice(
                  text: "پایان داستان",
                  nextPage: -1,
                  achievementKey: "JEALOUSY")
            ]),
        const StoryPage(
            image: "",
            text:
                "این فکر اشتباه باعث می‌شود اعتماد به نفست را از دست بدهی و برای امتحان بعدی تلاش نکنی.",
            choices: [
              Choice(
                  text: "پایان داستان",
                  nextPage: -1,
                  achievementKey: "SELF_DOUBT")
            ]),
        const StoryPage(
            image: "",
            text:
                "مریم از تبریک تو خوشحال می‌شود و حتی پیشنهاد می‌دهد در درس‌ها به تو کمک کند. تو هم برای پیشرفت خودت مصمم می‌شوی.",
            choices: [
              Choice(
                  text: "پایان داستان",
                  nextPage: -1,
                  achievementKey: "APPRECIATION",
                  isSuccess: true)
            ]),
      ]),
  // داستان ۱۸: یک روز بد
  Story(
      id: "badDay",
      title: "یک روز بد",
      description: "چطور با احساسات منفی خود کنار بیاییم؟",
      icon: Icons.cloud,
      gradientColors: [const Color(0xFF616161), const Color(0xFF9BC5C3)],
      requiredStars: 8,
      achievements: {
        "ANGER_OUTBURST": "یاد گرفتم که ناراحتی‌ام را سر دیگران خالی نکنم.",
        "SUPPRESSION":
            "فهمیدم که ریختن احساسات در خودم، کمکی به بهتر شدن حالم نمی‌کند.",
        "SHARING_FEELINGS":
            "آفرین! صحبت کردن درباره احساساتم با کسی که به او اعتماد دارم، خیلی کمک کننده است."
      },
      pages: [
        const StoryPage(
            image: "",
            text:
                "امروز اصلا روز خوبی نیست. صبحانه از دستت افتاد و تکالیفت را جا گذاشته‌ای. خیلی بی‌حوصله هستی.",
            choices: [
              Choice(text: "سر دوستم داد می‌زنم.", nextPage: 1),
              Choice(text: "با هیچکس حرف نمی‌زنم.", nextPage: 2),
              Choice(text: "بعد از مدرسه با والدینم صحبت می‌کنم.", nextPage: 3),
            ]),
        const StoryPage(
            image: "",
            text: "دوستت از رفتار تو خیلی ناراحت می‌شود و تو هم پشیمان می‌شوی.",
            choices: [
              Choice(
                  text: "پایان داستان",
                  nextPage: -1,
                  achievementKey: "ANGER_OUTBURST")
            ]),
        const StoryPage(
            image: "",
            text:
                "تو تمام روز را با حال بد گذراندی و هیچکس نفهمید چرا ناراحتی.",
            choices: [
              Choice(
                  text: "پایان داستان",
                  nextPage: -1,
                  achievementKey: "SUPPRESSION")
            ]),
        const StoryPage(
            image: "",
            text:
                "والدینت به حرف‌هایت گوش می‌دهند و به تو کمک می‌کنند تا حالت بهتر شود. فردا روز بهتری خواهد بود.",
            choices: [
              Choice(
                  text: "پایان داستان",
                  nextPage: -1,
                  achievementKey: "SHARING_FEELINGS",
                  isSuccess: true)
            ]),
      ]),
  // داستان ۱۹: راز یواشکی
  Story(
      id: "badSecret",
      title: "راز یواشکی",
      description: "تفاوت بین راز خوب و راز بد چیست؟",
      icon: Icons.hearing_disabled,
      gradientColors: [const Color(0xFFff9a9e), const Color(0xFFfad0c4)],
      requiredStars: 9,
      achievements: {
        "GOSSIP": "فهمیدم که پخش کردن رازهای دیگران، کار اشتباهی است.",
        "KEEPING_DANGEROUS_SECRET":
            "یاد گرفتم که رازهای بد و خطرناک را باید به بزرگترها گفت.",
        "HELPING_A_FRIEND":
            "آفرین! کمک به یک دوست برای گفتن رازش به یک بزرگتر، بهترین کار است."
      },
      pages: [
        const StoryPage(
            image: "",
            text:
                "دوستت به تو رازی را می‌گوید که به نظر خطرناک می‌آید و از تو می‌خواهد به کسی نگویی.",
            choices: [
              Choice(text: "به بقیه بچه‌ها می‌گویم.", nextPage: 1),
              Choice(text: "قول می‌دهم به کسی نگویم.", nextPage: 2),
              Choice(
                  text: "دوستم را تشویق می‌کنم با مشاور مدرسه صحبت کند.",
                  nextPage: 3),
            ]),
        const StoryPage(
            image: "",
            text:
                "دوستت از اینکه رازش را فاش کردی، به شدت ناراحت می‌شود و دیگر به تو اعتماد نمی‌کند.",
            choices: [
              Choice(
                  text: "پایان داستان", nextPage: -1, achievementKey: "GOSSIP")
            ]),
        const StoryPage(
            image: "",
            text:
                "تو راز را نگه می‌داری، اما دوستت همچنان در خطر است و تو هم استرس داری.",
            choices: [
              Choice(
                  text: "پایان داستان",
                  nextPage: -1,
                  achievementKey: "KEEPING_DANGEROUS_SECRET")
            ]),
        const StoryPage(
            image: "",
            text:
                "تو با دوستت پیش مشاور می‌روید. مشاور به او کمک می‌کند و دوستت از تو برای این کمک بزرگ ممنون است.",
            choices: [
              Choice(
                  text: "پایان داستان",
                  nextPage: -1,
                  achievementKey: "HELPING_A_FRIEND",
                  isSuccess: true)
            ]),
      ]),
  // داستان ۲۰: وقتی غریبه‌ای کمک می‌خواهد
  Story(
      id: "strangerDanger",
      title: "وقتی غریبه‌ای کمک می‌خواهد",
      description: "چطور در مقابل غریبه‌ها از خودمان محافظت کنیم؟",
      icon: Icons.person_off,
      gradientColors: [const Color(0xFFff4b1f), const Color(0xFFff9068)],
      requiredStars: 9,
      achievements: {
        "GOING_ALONG": "یاد گرفتم که هرگز نباید با یک غریبه جایی بروم.",
        "IGNORING": "فهمیدم که گاهی نادیده گرفتن کافی نیست و باید کمک خواست.",
        "SAFETY_FIRST":
            "آفرین! 'نه' گفتن، فرار کردن و خبر دادن به بزرگترها، بهترین راه محافظت از خود است."
      },
      pages: [
        const StoryPage(
            image: "",
            text:
                "نزدیک مدرسه، یک غریبه تو را صدا می‌زند و می‌گوید برای پیدا کردن گربه‌اش به کمک تو نیاز دارد.",
            choices: [
              Choice(text: "با او می‌روم تا کمکش کنم.", nextPage: 1),
              Choice(text: "نادیده‌اش می‌گیرم و رد می‌شوم.", nextPage: 2),
              Choice(
                  text: "بلند می‌گویم 'نه' و به سمت یک بزرگتر می‌دوم.",
                  nextPage: 3),
            ]),
        const StoryPage(
            image: "",
            text:
                "این کار بسیار خطرناکی است. هرگز نباید با یک غریبه همراه شوی.",
            choices: [
              Choice(
                  text: "پایان داستان",
                  nextPage: -1,
                  achievementKey: "GOING_ALONG")
            ]),
        const StoryPage(
            image: "",
            text:
                "شاید از خطر دور شوی، اما آن فرد غریبه ممکن است از بچه‌های دیگر هم همین درخواست را بکند.",
            choices: [
              Choice(
                  text: "پایان داستان",
                  nextPage: -1,
                  achievementKey: "IGNORING")
            ]),
        const StoryPage(
            image: "",
            text:
                "تو به سمت اولین مغازه می‌دوی و ماجرا را برای فروشنده تعریف می‌کنی. او با پلیس تماس می‌گیرد. تو کار بسیار درستی کردی!",
            choices: [
              Choice(
                  text: "پایان داستان",
                  nextPage: -1,
                  achievementKey: "SAFETY_FIRST",
                  isSuccess: true)
            ]),
      ]),
  // داستان ۲۱: مسابقه غیرمنصفانه
  Story(
      id: "unfairRace",
      title: "مسابقه غیرمنصفانه",
      description: "داستانی درباره تقلب و ارزش بازی جوانمردانه.",
      icon: Icons.directions_run,
      gradientColors: [const Color(0xFFFFA500), const Color(0xFFFFD700)],
      requiredStars: 10,
      achievements: {
        "CHEATING": "یاد گرفتم که بردن با تقلب هیچ ارزشی ندارد.",
        "SILENCE_CHEAT": "فهمیدم که سکوت در برابر تقلب هم کار درستی نیست.",
        "FAIR_PLAY": "آفرین! بازی جوانمردانه و تلاش کردن، از بردن مهم‌تر است."
      },
      pages: [
        const StoryPage(
            image: "",
            text:
                "در مسابقه دوی مدرسه، دوستت پیشنهاد می‌دهد که از یک راه میان‌بر بروید تا برنده شوید.",
            choices: [
              Choice(text: "قبول می‌کنم!", nextPage: 1),
              Choice(text: "مخالفت می‌کنم ولی چیزی نمی‌گویم.", nextPage: 2),
              Choice(
                  text: "می‌گویم این کار تقلب است و راه درست را می‌روم.",
                  nextPage: 3),
            ]),
        const StoryPage(
            image: "",
            text:
                "شما برنده می‌شوید، اما همه می‌فهمند که تقلب کرده‌اید و مدال را از شما پس می‌گیرند.",
            choices: [
              Choice(
                  text: "پایان داستان",
                  nextPage: -1,
                  achievementKey: "CHEATING")
            ]),
        const StoryPage(
            image: "",
            text:
                "دوستت تقلب می‌کند و برنده می‌شود. تو احساس بدی داری چون کار درست را انجام ندادی.",
            choices: [
              Choice(
                  text: "پایان داستان",
                  nextPage: -1,
                  achievementKey: "SILENCE_CHEAT")
            ]),
        const StoryPage(
            image: "",
            text:
                "تو با افتخار مسابقه را تمام می‌کنی، حتی اگر نفر اول نشوی. معلم از جوانمردی تو تقدیر می‌کند.",
            choices: [
              Choice(
                  text: "پایان داستان",
                  nextPage: -1,
                  achievementKey: "FAIR_PLAY",
                  isSuccess: true)
            ]),
      ]),
  // داستان ۲۲: قولی که فراموش شد
  Story(
      id: "forgottenPromise",
      title: "قولی که فراموش شد",
      description: "داستانی درباره مسئولیت‌پذیری و عذرخواهی.",
      icon: Icons.event_busy,
      gradientColors: [const Color(0xFF8E2DE2), const Color(0xFF4A00E0)],
      requiredStars: 10,
      achievements: {
        "DENIAL": "یاد گرفتم که انکار کردن قول، بی‌اعتمادی به وجود می‌آورد.",
        "EXCUSES": "یاد گرفتم که بهانه‌آوردن، بی‌مسئولیتی است.",
        "APOLOGY":
            "آفرین! عذرخواهی صادقانه و جبران اشتباه، دوستی‌ها را قوی‌تر می‌کند."
      },
      pages: [
        const StoryPage(
            image: "",
            text:
                "قول داده بودی بعد از مدرسه در درس‌ها به دوستت کمک کنی، اما کاملاً فراموش کردی و به خانه رفتی.",
            choices: [
              Choice(text: "می‌گویم اصلاً چنین قولی نداده‌ام.", nextPage: 1),
              Choice(text: "یک بهانه می‌آورم.", nextPage: 2),
              Choice(
                  text: "صادقانه عذرخواهی می‌کنم و جبران می‌کنم.", nextPage: 3),
            ]),
        const StoryPage(
            image: "",
            text:
                "دوستت از دست تو خیلی ناراحت می‌شود و دیگر روی حرف‌هایت حساب نمی‌کند.",
            choices: [
              Choice(
                  text: "پایان داستان", nextPage: -1, achievementKey: "DENIAL")
            ]),
        const StoryPage(
            image: "",
            text:
                "دوستت شاید بهانه‌ات را قبول کند، اما تو می‌دانی که کار درستی نکرده‌ای.",
            choices: [
              Choice(
                  text: "پایان داستان", nextPage: -1, achievementKey: "EXCUSES")
            ]),
        const StoryPage(
            image: "",
            text:
                "دوستت از صداقت تو قدردانی می‌کند و برای یک روز دیگر با هم قرار می‌گذارید.",
            choices: [
              Choice(
                  text: "پایان داستان",
                  nextPage: -1,
                  achievementKey: "APOLOGY",
                  isSuccess: true)
            ]),
      ]),
  // داستان ۲۳: میز شلخته
  Story(
      id: "messyDesk",
      title: "میز شلخته",
      description: "چطور با احترام به دیگران تذکر دهیم؟",
      icon: Icons.cleaning_services_outlined,
      gradientColors: [const Color(0xFF966F33), const Color(0xFFC4A484)],
      requiredStars: 11,
      achievements: {
        "DOING_IT_FOR_THEM": "یاد گرفتم که حل کردن مشکل دیگران، وظیفه من نیست.",
        "ESCALATING": "فهمیدم که بهتر است اول خودم برای حل مشکل تلاش کنم.",
        "KIND_CONVERSATION":
            "آفرین! با گفتگوی محترمانه می‌توانیم مشکلاتمان را با دیگران حل کنیم."
      },
      pages: [
        const StoryPage(
            image: "",
            text: "میز همکلاسی‌ات آنقدر شلخته است که وسایلش روی میز تو ریخته.",
            choices: [
              Choice(text: "وسایلش را برایش جمع می‌کنم.", nextPage: 1),
              Choice(text: "به معلم می‌گویم.", nextPage: 2),
              Choice(
                  text: "با مهربانی از او می‌خواهم وسایلش را جمع کند.",
                  nextPage: 3),
            ]),
        const StoryPage(
            image: "",
            text:
                "تو میز را مرتب می‌کنی، اما او یاد نمی‌گیرد که باید خودش این کار را انجام دهد.",
            choices: [
              Choice(
                  text: "پایان داستان",
                  nextPage: -1,
                  achievementKey: "DOING_IT_FOR_THEM")
            ]),
        const StoryPage(
            image: "",
            text:
                "معلم از همکلاسی‌ات می‌خواهد میزش را تمیز کند، اما شاید بهتر بود اول خودت با او صحبت می‌کردی.",
            choices: [
              Choice(
                  text: "پایان داستان",
                  nextPage: -1,
                  achievementKey: "ESCALATING")
            ]),
        const StoryPage(
            image: "",
            text:
                "همکلاسی‌ات عذرخواهی می‌کند و وسایلش را جمع می‌کند. مشکل به سادگی حل شد!",
            choices: [
              Choice(
                  text: "پایان داستان",
                  nextPage: -1,
                  achievementKey: "KIND_CONVERSATION",
                  isSuccess: true)
            ]),
      ]),
  // داستان ۲۴: ترس از کنفرانس
  Story(
      id: "stageFright",
      title: "ترس از کنفرانس",
      description: "چطور بر خجالت غلبه کنیم و دیگران را تشویق کنیم؟",
      icon: Icons.mic_external_on,
      gradientColors: [const Color(0xFF4e54c8), const Color(0xFF8f94fb)],
      requiredStars: 11,
      achievements: {
        "AVOIDANCE": "فهمیدم که فرار کردن از ترس‌ها، آنها را بزرگتر می‌کند.",
        "LAUGHING": "یاد گرفتم که مسخره کردن دیگران، کار بسیار اشتباهی است.",
        "SUPPORT": "آفرین! حمایت و تشویق دوستان، به همه ما جرأت می‌دهد."
      },
      pages: [
        const StoryPage(
            image: "",
            text:
                "نوبت کنفرانس دوستت، علی، است. او خیلی استرس دارد و صدایش می‌لرزد.",
            choices: [
              Choice(
                  text: "من هم استرس می‌گیرم و جای دیگری را نگاه می‌کنم.",
                  nextPage: 1),
              Choice(text: "به لرزش صدایش می‌خندم.", nextPage: 2),
              Choice(text: "به او لبخند می‌زنم و سر تکان می‌دهم.", nextPage: 3),
            ]),
        const StoryPage(
            image: "",
            text:
                "تو به علی کمکی نمی‌کنی و او هم با استرس کنفرانسش را تمام می‌کند.",
            choices: [
              Choice(
                  text: "پایان داستان",
                  nextPage: -1,
                  achievementKey: "AVOIDANCE")
            ]),
        const StoryPage(
            image: "",
            text:
                "علی با دیدن خنده تو، بیشتر استرس می‌گیرد و ممکن است دیگر هرگز کنفرانس ندهد.",
            choices: [
              Choice(
                  text: "پایان داستان",
                  nextPage: -1,
                  achievementKey: "LAUGHING")
            ]),
        const StoryPage(
            image: "",
            text:
                "علی با دیدن حمایت تو، آرامش پیدا می‌کند و با اعتماد به نفس بیشتری کنفرانسش را ادامه می‌دهد.",
            choices: [
              Choice(
                  text: "پایان داستان",
                  nextPage: -1,
                  achievementKey: "SUPPORT",
                  isSuccess: true)
            ]),
      ]),
  // داستان ۲۵: ظرف غذای متفاوت
  Story(
      id: "differentLunch",
      title: "ظرف غذای متفاوت",
      description: "داستانی درباره احترام به تفاوت‌ها و فرهنگ‌ها.",
      icon: Icons.food_bank,
      gradientColors: [const Color(0xFFff6e7f), const Color(0xFFbfe9ff)],
      requiredStars: 12,
      achievements: {
        "MAKING_FUN":
            "یاد گرفتم که مسخره کردن تفاوت‌ها، دیگران را آزار می‌دهد.",
        "IGNORANCE":
            "فهمیدم که دوری کردن از چیزهای جدید، فرصت یادگیری را از من می‌گیرد.",
        "CURIOSITY":
            "آفرین! کنجکاوی محترمانه درباره تفاوت‌ها، باعث شناخت و دوستی می‌شود."
      },
      pages: [
        const StoryPage(
            image: "",
            text:
                "همکلاسی جدیدت، کیمیا، ناهاری آورده که بوی متفاوتی دارد و تو تا به حال ندیده‌ای.",
            choices: [
              Choice(
                  text: "دماغم را می‌گیرم و می‌گویم: 'چه بوی بدی!'",
                  nextPage: 1),
              Choice(text: "از او فاصله می‌گیرم.", nextPage: 2),
              Choice(text: "با کنجکاوی می‌پرسم: 'غذایت چیست؟'", nextPage: 3),
            ]),
        const StoryPage(
            image: "",
            text: "کیمیا از حرف تو خجالت می‌کشد و ناراحت می‌شود.",
            choices: [
              Choice(
                  text: "پایان داستان",
                  nextPage: -1,
                  achievementKey: "MAKING_FUN")
            ]),
        const StoryPage(
            image: "",
            text: "تو فرصت آشنایی با یک فرهنگ و طعم جدید را از دست می‌دهی.",
            choices: [
              Choice(
                  text: "پایان داستان",
                  nextPage: -1,
                  achievementKey: "IGNORANCE")
            ]),
        const StoryPage(
            image: "",
            text:
                "کیمیا با خوشحالی درباره غذای محلی‌شان برایت توضیح می‌دهد و حتی به تو تعارف می‌کند. تو یک دوست جدید پیدا می‌کنی!",
            choices: [
              Choice(
                  text: "پایان داستان",
                  nextPage: -1,
                  achievementKey: "CURIOSITY",
                  isSuccess: true)
            ]),
      ]),
  // داستان ۲۶: دروغ مصلحتی
  Story(
      id: "whiteLie",
      title: "دروغ مصلحتی",
      description: "آیا دروغ‌های کوچک هم بد هستند؟",
      icon: Icons.question_answer,
      gradientColors: [const Color(0xFF757F9A), const Color(0xFFD7DDE8)],
      requiredStars: 12,
      achievements: {
        "EASY_LIE":
            "یاد گرفتم که حتی دروغ‌های کوچک هم می‌توانند باعث دردسر شوند.",
        "BLAME_SHIFT":
            "فهمیدم که انداختن تقصیر گردن دیگران، کار ناجوانمردانه‌ای است.",
        "TRUTH": "آفرین! راستگویی همیشه بهترین راه است، حتی اگر سخت باشد."
      },
      pages: [
        const StoryPage(
            image: "",
            text: "تو تکالیفت را انجام نداده‌ای. معلم از تو می‌پرسد چرا؟",
            choices: [
              Choice(
                  text: "می‌گویم: 'دفترم را در خانه جا گذاشتم.'", nextPage: 1),
              Choice(
                  text: "می‌گویم: 'برادرم دفترم را خط‌خطی کرد.'", nextPage: 2),
              Choice(text: "حقیقت را می‌گویم.", nextPage: 3),
            ]),
        const StoryPage(
            image: "",
            text:
                "معلم می‌گوید: 'اشکالی ندارد، فردا بیاور.' اما تو تمام روز استرس داری که دروغت فاش شود.",
            choices: [
              Choice(
                  text: "پایان داستان",
                  nextPage: -1,
                  achievementKey: "EASY_LIE")
            ]),
        const StoryPage(
            image: "",
            text:
                "این یک دروغ بزرگتر و یک کار بسیار اشتباه است که دیگری را مقصر کنی.",
            choices: [
              Choice(
                  text: "پایان داستان",
                  nextPage: -1,
                  achievementKey: "BLAME_SHIFT")
            ]),
        const StoryPage(
            image: "",
            text:
                "معلم از صداقت تو خوشحال می‌شود و به تو یک فرصت دیگر می‌دهد تا تکالیفت را انجام دهی.",
            choices: [
              Choice(
                  text: "پایان داستان",
                  nextPage: -1,
                  achievementKey: "TRUTH",
                  isSuccess: true)
            ]),
      ]),
  // داستان ۲۷: باشگاه مخفی
  Story(
      id: "secretClub",
      title: "باشگاه مخفی",
      description: "چطور با طرد شدن از طرف گروه‌ها کنار بیاییم؟",
      icon: Icons.lock_person,
      gradientColors: [const Color(0xFF0F2027), const Color(0xFF2C5364)],
      requiredStars: 13,
      achievements: {
        "BEGGING":
            "یاد گرفتم که التماس کردن برای ورود به یک گروه، ارزشم را پایین می‌آورد.",
        "REVENGE_CLUB": "فهمیدم که مقابله به مثل، کار درستی نیست.",
        "SELF_WORTH":
            "آفرین! من برای شاد بودن به تایید دیگران نیاز ندارم و می‌توانم سرگرمی‌های خودم را داشته باشم."
      },
      pages: [
        const StoryPage(
            image: "",
            text:
                "چند نفر از همکلاسی‌هایت یک 'باشگاه مخفی' تشکیل داده‌اند و تو را راه نمی‌دهند.",
            choices: [
              Choice(text: "به آنها التماس می‌کنم.", nextPage: 1),
              Choice(
                  text: "من هم یک باشگاه مخفی دیگر درست می‌کنم.", nextPage: 2),
              Choice(text: "بی‌خیال می‌شوم و کار خودم را می‌کنم.", nextPage: 3),
            ]),
        const StoryPage(
            image: "",
            text: "آنها بیشتر از تو فاصله می‌گیرند و تو احساس بدی پیدا می‌کنی.",
            choices: [
              Choice(
                  text: "پایان داستان", nextPage: -1, achievementKey: "BEGGING")
            ]),
        const StoryPage(
            image: "",
            text:
                "این کار فقط باعث ایجاد گروه‌های بیشتر و دعوا در کلاس می‌شود.",
            choices: [
              Choice(
                  text: "پایان داستان",
                  nextPage: -1,
                  achievementKey: "REVENGE_CLUB")
            ]),
        const StoryPage(
            image: "",
            text:
                "تو کتاب مورد علاقه‌ات را می‌خوانی. کمی بعد، یکی از بچه‌ها که او هم در باشگاه نیست، پیش تو می‌آید و یک دوستی جدید شکل می‌گیرد.",
            choices: [
              Choice(
                  text: "پایان داستان",
                  nextPage: -1,
                  achievementKey: "SELF_WORTH",
                  isSuccess: true)
            ]),
      ]),
  // داستان ۲۸: اسباب‌بازی شکسته
  Story(
      id: "brokenToy",
      title: "اسباب‌بازی شکسته",
      description: "وقتی به طور اتفاقی به چیزی آسیب می‌زنیم.",
      icon: Icons.build_circle,
      gradientColors: [const Color(0xFFCB2D38), const Color(0xFF642B73)],
      requiredStars: 13,
      achievements: {
        "HIDING_IT": "یاد گرفتم که پنهان کردن اشتباه، مشکل را بدتر می‌کند.",
        "BLAMING_SOMEONE_ELSE": "فهمیدم که مقصر کردن دیگران، ناجوانمردانه است.",
        "OWNING_UP": "آفرین! پذیرفتن اشتباه و تلاش برای جبران، بهترین کار است."
      },
      pages: [
        const StoryPage(
            image: "",
            text:
                "در خانه دوستت هستی و به طور اتفاقی، اسباب‌بازی مورد علاقه‌اش را می‌شکنی.",
            choices: [
              Choice(text: "آن را یک گوشه قایم می‌کنم.", nextPage: 1),
              Choice(text: "می‌گویم از اول شکسته بود.", nextPage: 2),
              Choice(text: "حقیقت را به او می‌گویم.", nextPage: 3),
            ]),
        const StoryPage(
            image: "",
            text:
                "دوستت بالاخره آن را پیدا می‌کند و از اینکه به او دروغ گفته‌ای، دو برابر ناراحت می‌شود.",
            choices: [
              Choice(
                  text: "پایان داستان",
                  nextPage: -1,
                  achievementKey: "HIDING_IT")
            ]),
        const StoryPage(
            image: "",
            text: "این کار بی‌اعتمادی بزرگی بین شما ایجاد می‌کند.",
            choices: [
              Choice(
                  text: "پایان داستان",
                  nextPage: -1,
                  achievementKey: "BLAMING_SOMEONE_ELSE")
            ]),
        const StoryPage(
            image: "",
            text:
                "دوستت اول ناراحت می‌شود، اما از صداقت تو خوشش می‌آید و با کمک هم سعی می‌کنید آن را تعمیر کنید.",
            choices: [
              Choice(
                  text: "پایان داستان",
                  nextPage: -1,
                  achievementKey: "OWNING_UP",
                  isSuccess: true)
            ]),
      ]),
  // داستان ۲۹: دوست همیشه برنده
  Story(
      id: "competitiveFriend",
      title: "دوست همیشه برنده",
      description: "چطور با دوستی که خیلی رقابتی است، کنار بیاییم؟",
      icon: Icons.emoji_events,
      gradientColors: [const Color(0xFF00c6ff), const Color(0xFF0072ff)],
      requiredStars: 14,
      achievements: {
        "QUITTING": "یاد گرفتم که کنار کشیدن، راه حل خوبی برای مشکلات نیست.",
        "ARGUMENT": "فهمیدم که دعوا کردن، فقط دوستی را خراب می‌کند.",
        "FOCUS_ON_FUN":
            "آفرین! یادآوری اینکه هدف از بازی لذت بردن است، به همه کمک می‌کند."
      },
      pages: [
        const StoryPage(
            image: "",
            text:
                "دوستت در هر بازی فقط به بردن فکر می‌کند و اگر ببازد، عصبانی می‌شود.",
            choices: [
              Choice(text: "دیگر با او بازی نمی‌کنم.", nextPage: 1),
              Choice(text: "با او دعوا می‌کنم.", nextPage: 2),
              Choice(
                  text: "به او می‌گویم: 'بیا فقط از بازی لذت ببریم.'",
                  nextPage: 3),
            ]),
        const StoryPage(
            image: "",
            text: "این کار ممکن است باعث شود دوستی شما به کلی تمام شود.",
            choices: [
              Choice(
                  text: "پایان داستان",
                  nextPage: -1,
                  achievementKey: "QUITTING")
            ]),
        const StoryPage(
            image: "",
            text:
                "دعوای شما فقط باعث ناراحتی هر دوی شما می‌شود و مشکل حل نمی‌شود.",
            choices: [
              Choice(
                  text: "پایان داستان",
                  nextPage: -1,
                  achievementKey: "ARGUMENT")
            ]),
        const StoryPage(
            image: "",
            text:
                "دوستت کمی فکر می‌کند و قبول می‌کند. شما یاد می‌گیرید که با هم بازی کنید و از آن لذت ببرید، نه فقط از بردن.",
            choices: [
              Choice(
                  text: "پایان داستان",
                  nextPage: -1,
                  achievementKey: "FOCUS_ON_FUN",
                  isSuccess: true)
            ]),
      ]),
  // داستان ۳۰: تقسیم کردن توجه
  Story(
      id: "sharingSpotlight",
      title: "تقسیم کردن توجه",
      description: "یاد می‌گیریم برای موفقیت دیگران هم خوشحال باشیم.",
      icon: Icons.celebration,
      gradientColors: [const Color(0xFFED213A), const Color(0xFF93291E)],
      requiredStars: 15,
      achievements: {
        "INTERRUPTING":
            "یاد گرفتم که حرف دیگران را قطع نکنم و به آنها هم فرصت بدهم.",
        "JEALOUSY_SUCCESS":
            "فهمیدم که حسادت به موفقیت دوستانم، کار درستی نیست.",
        "BEING_HAPPY_FOR_OTHERS":
            "آفرین! خوشحال شدن برای دیگران، نشانه یک قلب بزرگ و یک دوستی واقعی است."
      },
      pages: [
        const StoryPage(
            image: "",
            text:
                "معلم در حال تشویق دوستت برای کار خوبی است که انجام داده. تو هم دلت می‌خواهد تشویق شوی.",
            choices: [
              Choice(
                  text: "حرف معلم را قطع می‌کنم و از کار خوب خودم می‌گویم.",
                  nextPage: 1),
              Choice(text: "بی‌محلی می‌کنم.", nextPage: 2),
              Choice(text: "من هم برای دوستم دست می‌زنم.", nextPage: 3),
            ]),
        const StoryPage(
            image: "",
            text: "معلم از کارت ناراحت می‌شود و دوستت هم دلخور می‌شود.",
            choices: [
              Choice(
                  text: "پایان داستان",
                  nextPage: -1,
                  achievementKey: "INTERRUPTING")
            ]),
        const StoryPage(
            image: "",
            text:
                "تو فرصت خوشحال کردن دوستت و نشان دادن شخصیت خوبت را از دست می‌دهی.",
            choices: [
              Choice(
                  text: "پایان داستان",
                  nextPage: -1,
                  achievementKey: "JEALOUSY_SUCCESS")
            ]),
        const StoryPage(
            image: "",
            text:
                "دوستت از حمایت تو خیلی خوشحال می‌شود و معلم هم از رفتار هر دوی شما تقدیر می‌کند.",
            choices: [
              Choice(
                  text: "پایان داستان",
                  nextPage: -1,
                  achievementKey: "BEING_HAPPY_FOR_OTHERS",
                  isSuccess: true)
            ]),
      ]),
];

// --- ویجت اصلی اپلیکیشن ---
class InteractiveStoryApp extends StatelessWidget {
  final String? avatarData;
  const InteractiveStoryApp({super.key, this.avatarData});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'کتاب ماجراهای من',
      theme: ThemeData(
        brightness: Brightness.light,
        fontFamily: 'Vazirmatn',
        primarySwatch: Colors.blue,
      ),
      debugShowCheckedModeBanner: false,
      builder: (context, child) {
        return Directionality(
          textDirection: TextDirection.rtl,
          child: child!,
        );
      },
      home: avatarData == null
          ? const AvatarCreationScreen()
          : MainScreen(avatarData: avatarData!),
    );
  }
}

// --- صفحه ساخت آواتار ---
class AvatarCreationScreen extends StatefulWidget {
  const AvatarCreationScreen({super.key});

  @override
  State<AvatarCreationScreen> createState() => _AvatarCreationScreenState();
}

class _AvatarCreationScreenState extends State<AvatarCreationScreen> {
  bool _isBoy = true;
  Color _selectedColor = Colors.blue;
  final List<Color> _colors = [
    Colors.blue,
    Colors.green,
    Colors.red,
    Colors.orange,
    Colors.purple,
    Colors.teal
  ];

  void _saveAvatarAndStart() async {
    final avatar = Avatar(isBoy: _isBoy, shirtColor: _selectedColor);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('user_avatar', jsonEncode(avatar.toJson()));

    if (mounted) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
            builder: (context) =>
                MainScreen(avatarData: jsonEncode(avatar.toJson()))),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFE0EAFC), Color(0xFFCFDEF3)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("شخصیت خودت رو بساز!",
                      style:
                          TextStyle(fontSize: 32, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 40),
                  Icon(_isBoy ? Icons.face_retouching_natural : Icons.face_4,
                      size: 150, color: _selectedColor),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ChoiceChip(
                        label: const Text("پسر"),
                        selected: _isBoy,
                        onSelected: (selected) => setState(() => _isBoy = true),
                        selectedColor: Colors.blue[200],
                      ),
                      const SizedBox(width: 20),
                      ChoiceChip(
                        label: const Text("دختر"),
                        selected: !_isBoy,
                        onSelected: (selected) =>
                            setState(() => _isBoy = false),
                        selectedColor: Colors.pink[200],
                      ),
                    ],
                  ),
                  const SizedBox(height: 30),
                  const Text("رنگ لباست رو انتخاب کن:"),
                  const SizedBox(height: 10),
                  Wrap(
                    spacing: 10,
                    children: _colors.map((color) {
                      return ChoiceChip(
                        label: const SizedBox(),
                        backgroundColor: color,
                        selected: _selectedColor == color,
                        onSelected: (selected) =>
                            setState(() => _selectedColor = color),
                        shape: CircleBorder(
                            side: BorderSide(
                                color: _selectedColor == color
                                    ? Colors.black
                                    : Colors.transparent,
                                width: 3)),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 50),
                  ElevatedButton(
                    onPressed: _saveAvatarAndStart,
                    child: const Text("شروع ماجراجویی"),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 40, vertical: 15),
                      textStyle: const TextStyle(
                          fontSize: 18, fontFamily: 'Vazirmatn'),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// --- مدیریت کننده صفحات ---
class MainScreen extends StatefulWidget {
  final String avatarData;
  const MainScreen({super.key, required this.avatarData});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  Story? _currentStory;
  int _currentPageIndex = 0;
  Map<String, String> _learnedLessons = {};
  late Avatar _userAvatar;

  @override
  void initState() {
    super.initState();
    _userAvatar = Avatar.fromJson(jsonDecode(widget.avatarData));
    _loadLearnedLessons();
  }

  void _loadLearnedLessons() async {
    final prefs = await SharedPreferences.getInstance();
    final lessonsJson = prefs.getString('learned_lessons');
    if (lessonsJson != null) {
      setState(() {
        _learnedLessons = Map<String, String>.from(jsonDecode(lessonsJson));
      });
    }
  }

  void _saveLearnedLessons() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('learned_lessons', jsonEncode(_learnedLessons));
  }

  void _startStory(Story story) {
    if (story.pages.isEmpty) return;
    int currentStars = _learnedLessons.values.where((key) {
      final relevantStory = stories.firstWhere(
          (s) => s.achievements.containsKey(key),
          orElse: () => stories.first);
      return relevantStory.achievements[key]!.startsWith("آفرین");
    }).length;

    if (story.requiredStars > currentStars) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
              'برای باز کردن این داستان به ${story.requiredStars} ستاره نیاز داری!'),
          backgroundColor: Colors.redAccent,
        ),
      );
      return;
    }

    int initialPageIndex = 0;
    if (story.id == "winningLosing") {
      initialPageIndex = Random().nextBool() ? 0 : 3;
    }

    setState(() {
      _currentStory = story;
      _currentPageIndex = initialPageIndex;
    });
  }

  void _goHome() {
    setState(() {
      _currentStory = null;
    });
  }

  void _handleChoice(Choice choice) {
    if (choice.nextPage == -1) {
      if (choice.achievementKey != null) {
        final lesson = _currentStory!.achievements[choice.achievementKey!];
        if (lesson != null) {
          setState(() {
            _learnedLessons[_currentStory!.id] = choice.achievementKey!;
          });
          _saveLearnedLessons();
          _showLessonDialog(lesson, choice.isSuccess);
        } else {
          _goHome();
        }
      } else {
        _goHome();
      }
    } else {
      setState(() {
        _currentPageIndex = choice.nextPage;
      });
    }
  }

  void _showLessonDialog(String lesson, bool isSuccess) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
          child: AlertDialog(
            backgroundColor: Colors.white.withOpacity(0.85),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            icon: Icon(
              isSuccess ? Icons.star_rounded : Icons.lightbulb_rounded,
              color: isSuccess ? Colors.amber : Colors.blueAccent,
              size: 48,
            ),
            title: Text(
              isSuccess ? 'آفرین!' : 'یک درس جدید!',
              textAlign: TextAlign.center,
              style:
                  TextStyle(fontWeight: FontWeight.bold, color: Colors.black87),
            ),
            content: Text(
              lesson,
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.black87, fontSize: 16),
            ),
            actionsAlignment: MainAxisAlignment.center,
            actions: <Widget>[
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: isSuccess ? Colors.amber : Colors.blueAccent,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                ),
                child: const Text('بازگشت به کتابخانه',
                    style: TextStyle(color: Colors.white)),
                onPressed: () {
                  Navigator.of(context).pop();
                  _goHome();
                },
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFE0EAFC), Color(0xFFCFDEF3)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 500),
          transitionBuilder: (child, animation) {
            return FadeTransition(opacity: animation, child: child);
          },
          child: _currentStory != null
              ? StoryScreen(
                  key: ValueKey(_currentStory!.id),
                  story: _currentStory!,
                  pageIndex: _currentPageIndex,
                  onChoice: _handleChoice,
                  onBack: _goHome,
                )
              : BookshelfScreen(
                  key: const ValueKey('bookshelf'),
                  stories: stories,
                  onStorySelected: _startStory,
                  learnedLessons: _learnedLessons,
                  avatar: _userAvatar,
                ),
        ),
      ),
    );
  }
}

class BookshelfScreen extends StatelessWidget {
  final List<Story> stories;
  final Function(Story) onStorySelected;
  final Map<String, String> learnedLessons;
  final Avatar avatar;

  const BookshelfScreen({
    super.key,
    required this.stories,
    required this.onStorySelected,
    required this.learnedLessons,
    required this.avatar,
  });

  void _showAchievements(BuildContext context) {
    Navigator.of(context).push(PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) =>
          AchievementsScreen(learnedLessons: learnedLessons),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = Offset(0.0, 1.0);
        const end = Offset.zero;
        const curve = Curves.ease;
        var tween =
            Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
        return SlideTransition(position: animation.drive(tween), child: child);
      },
    ));
  }

  void _showEmotionsToolbox(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (context) => const EmotionsToolboxScreen()),
    );
  }

  void _showContactDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
          child: AlertDialog(
            backgroundColor: Colors.white.withOpacity(0.9),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            title: const Row(
              children: [
                Icon(Icons.info_outline_rounded, color: Colors.blueAccent),
                SizedBox(width: 10),
                Text("ارتباط با ما"),
              ],
            ),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text(
                    "این برنامه برای کمک به کودکان در یادگیری مهارت‌های اجتماعی و مقابله با چالش‌هایی مانند قلدری از طریق داستان‌های تعاملی ساخته شده است.",
                    style: TextStyle(fontSize: 15, height: 1.5),
                  ),
                  SizedBox(height: 20),
                  Text("سازنده: حمیدرضا علی میرزائی",
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  SizedBox(height: 8),
                  Text("ایمیل: alimirzaei.hr@gmail.com"),
                  SizedBox(height: 20),
                  Text(
                      "خوشحال می‌شویم نظرات و پیشنهادات شما را از طریق ایمیل دریافت کنیم."),
                ],
              ),
            ),
            actions: [
              TextButton(
                child: const Text("بستن",
                    style: TextStyle(
                        color: Colors.blueAccent, fontWeight: FontWeight.bold)),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              )
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final int currentStars = learnedLessons.values.where((key) {
      final story = stories.firstWhere((s) => s.achievements.containsKey(key),
          orElse: () => stories.first);
      return story.achievements[key]!.startsWith("آفرین");
    }).length;

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          children: [
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(Icons.star_rounded, color: Colors.amber, size: 30),
                    Text(" $currentStars",
                        style: const TextStyle(
                            fontSize: 24, fontWeight: FontWeight.bold)),
                  ],
                ),
                const Text('کتاب ماجراهای من',
                    style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF333333))),
                CircleAvatar(
                  radius: 25,
                  backgroundColor: avatar.shirtColor,
                  child: Icon(
                      avatar.isBoy
                          ? Icons.face_retouching_natural
                          : Icons.face_4,
                      size: 40,
                      color: Colors.white),
                ),
              ],
            ),
            const SizedBox(height: 30),
            Expanded(
              child: GridView.builder(
                padding: const EdgeInsets.only(bottom: 20),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 0.85,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                ),
                itemCount: stories.length,
                itemBuilder: (context, index) {
                  final story = stories[index];
                  final isLocked = story.requiredStars > currentStars;

                  return isLocked
                      ? LockedBookCover(story: story)
                      : BookCover(
                          story: story,
                          onTap: () => onStorySelected(story),
                        );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 20.0),
              child: Wrap(
                spacing: 12,
                runSpacing: 12,
                alignment: WrapAlignment.center,
                children: [
                  ElevatedButton.icon(
                    icon: const Icon(Icons.star_border_rounded,
                        color: Colors.white),
                    label: const Text('آموخته‌ها',
                        style: TextStyle(color: Colors.white, fontSize: 16)),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF6C63FF),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 15),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15)),
                      elevation: 5,
                    ),
                    onPressed: () => _showAchievements(context),
                  ),
                  OutlinedButton.icon(
                    icon: const Icon(Icons.psychology_outlined,
                        color: Color(0xFF6C63FF)),
                    label: const Text('احساسات',
                        style: TextStyle(
                            color: Color(0xFF6C63FF),
                            fontSize: 16,
                            fontWeight: FontWeight.w600)),
                    style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 15),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15)),
                        side: const BorderSide(
                            color: Color(0xFF6C63FF), width: 2)),
                    onPressed: () => _showEmotionsToolbox(context),
                  ),
                  OutlinedButton.icon(
                    icon: const Icon(Icons.email_outlined,
                        color: Color(0xFF6C63FF)),
                    label: const Text('تماس با ما',
                        style: TextStyle(
                            color: Color(0xFF6C63FF),
                            fontSize: 16,
                            fontWeight: FontWeight.w600)),
                    style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 15),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15)),
                        side: const BorderSide(
                            color: Color(0xFF6C63FF), width: 2)),
                    onPressed: () => _showContactDialog(context),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

class LockedBookCover extends StatelessWidget {
  final Story story;
  const LockedBookCover({super.key, required this.story});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20), color: Colors.grey.shade400),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 3, sigmaY: 3),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.lock, color: Colors.white, size: 60),
              const SizedBox(height: 10),
              Text("نیاز به ${story.requiredStars} ستاره",
                  style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 16))
            ],
          ),
        ),
      ),
    );
  }
}

class EmotionsToolboxScreen extends StatelessWidget {
  const EmotionsToolboxScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFffdde1), Color(0xFFee9ca7)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: Column(children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  const Text('جعبه ابزار احساسات',
                      style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.white)),
                  const Spacer(),
                  IconButton(
                    icon:
                        const Icon(Icons.close, color: Colors.white, size: 30),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: emotions.length,
                itemBuilder: (context, index) {
                  final emotion = emotions[index];
                  return Card(
                    color: Colors.white.withOpacity(0.9),
                    margin: const EdgeInsets.only(bottom: 12),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15)),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Icon(emotion.icon,
                                  color: emotion.color, size: 32),
                              const SizedBox(width: 15),
                              Text(emotion.name,
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      color: emotion.color)),
                            ],
                          ),
                          const SizedBox(height: 10),
                          Text(emotion.description,
                              style: const TextStyle(
                                  fontSize: 16,
                                  color: Colors.black87,
                                  height: 1.5))
                        ],
                      ),
                    ),
                  );
                },
              ),
            )
          ]),
        ),
      ),
    );
  }
}

class BookCover extends StatelessWidget {
  final Story story;
  final VoidCallback onTap;

  const BookCover({super.key, required this.story, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: LinearGradient(
          colors: story.gradientColors,
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: story.gradientColors.last.withOpacity(0.4),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: onTap,
            splashColor: Colors.white.withOpacity(0.2),
            highlightColor: Colors.white.withOpacity(0.1),
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Text(
                    story.title,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        shadows: [
                          Shadow(
                              color: Colors.black26,
                              blurRadius: 4,
                              offset: Offset(0, 2))
                        ]),
                  ),
                  Icon(story.icon, color: Colors.white, size: 70),
                  Text(
                    story.description,
                    textAlign: TextAlign.center,
                    style: const TextStyle(color: Colors.white70, fontSize: 12),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// --- صفحه ۲: صفحه داستان ---
class StoryScreen extends StatelessWidget {
  final Story story;
  final int pageIndex;
  final Function(Choice) onChoice;
  final VoidCallback onBack;

  const StoryScreen({
    super.key,
    required this.story,
    required this.pageIndex,
    required this.onChoice,
    required this.onBack,
  });

  @override
  Widget build(BuildContext context) {
    final page = story.pages[pageIndex];

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back_ios_new_rounded,
                        color: Colors.black54),
                    onPressed: onBack,
                  ),
                ],
              ),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: story.gradientColors,
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(15),
                    boxShadow: [
                      BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 10,
                          offset: Offset(0, 4))
                    ]),
                child: Text(
                  story.title,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                ),
              ),
              const SizedBox(height: 30),
              Expanded(
                child: Center(
                  child: Text(
                    page.text,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                        fontSize: 22, color: Colors.black87, height: 1.6),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              ...page.choices.map((choice) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: ElevatedButton(
                    onPressed: () => onChoice(choice),
                    style: ElevatedButton.styleFrom(
                        backgroundColor:
                            const Color(0xFFFFFFFF).withOpacity(0.8),
                        foregroundColor: Colors.black,
                        minimumSize: const Size(double.infinity, 55),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                            side: BorderSide(color: Colors.grey.shade300)),
                        elevation: 2),
                    child: Text(choice.text,
                        style: const TextStyle(
                            fontSize: 18, fontWeight: FontWeight.w600)),
                  ),
                );
              }).toList(),
            ],
          ),
        ),
      ),
    );
  }
}

// --- صفحه ۳: صفحه آموخته‌ها ---

class AnimatedListItem extends StatefulWidget {
  final Widget child;
  final int index;
  const AnimatedListItem({super.key, required this.child, required this.index});

  @override
  State<AnimatedListItem> createState() => _AnimatedListItemState();
}

class _AnimatedListItemState extends State<AnimatedListItem>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    _animation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Interval(
          (0.1 * widget.index).clamp(0.0, 1.0),
          1.0,
          curve: Curves.easeOut,
        ),
      ),
    );
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _animation,
      child: SlideTransition(
        position: Tween<Offset>(
          begin: const Offset(0, 0.5),
          end: Offset.zero,
        ).animate(_animation),
        child: widget.child,
      ),
    );
  }
}

class AchievementsScreen extends StatelessWidget {
  final Map<String, String> learnedLessons;
  const AchievementsScreen({super.key, required this.learnedLessons});

  Story? _findStoryById(String id) {
    try {
      return stories.firstWhere((story) => story.id == id);
    } catch (e) {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF6dd5ed), Color(0xFF2193b0)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  children: [
                    const Text('دفترچه آموخته‌ها',
                        style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.white)),
                    const Spacer(),
                    IconButton(
                      icon: const Icon(Icons.close,
                          color: Colors.white, size: 30),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: learnedLessons.isEmpty
                    ? const Center(
                        child: Text(
                          'هنوز هیچ درسی یاد نگرفته‌ای.\nیک داستان را تمام کن تا اولین نشانت را بگیری!',
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 18, color: Colors.white70),
                        ),
                      )
                    : ListView.builder(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        itemCount: learnedLessons.length,
                        itemBuilder: (context, index) {
                          final storyId = learnedLessons.keys.elementAt(index);
                          final achievementKey =
                              learnedLessons.values.elementAt(index);
                          final story = _findStoryById(storyId);
                          final lessonText =
                              story?.achievements[achievementKey];

                          if (story == null || lessonText == null) {
                            return const SizedBox.shrink();
                          }

                          return AnimatedListItem(
                            index: index,
                            child: Card(
                              color: Colors.white.withOpacity(0.9),
                              margin: const EdgeInsets.only(bottom: 12),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15)),
                              elevation: 4,
                              child: Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Icon(story.icon,
                                            color: story.gradientColors.first,
                                            size: 28),
                                        const SizedBox(width: 12),
                                        Expanded(
                                          child: Text(
                                            story.title,
                                            style: TextStyle(
                                                fontSize: 18,
                                                fontWeight: FontWeight.bold,
                                                color:
                                                    story.gradientColors.first),
                                          ),
                                        ),
                                      ],
                                    ),
                                    const Divider(height: 20, thickness: 1),
                                    Text(
                                      lessonText,
                                      style: const TextStyle(
                                          fontSize: 16, color: Colors.black87),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

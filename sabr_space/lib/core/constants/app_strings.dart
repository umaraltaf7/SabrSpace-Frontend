/// All visible text strings from the Stitch "Intro Screen" project.
class AppStrings {
  AppStrings._();

  // ─── App ───────────────────────────────────────────────
  static const String appName = 'Sabr Space';
  static const String tagline = 'Find peace in every breath.';

  // ─── Intro screen ──────────────────────────────────────
  static const String beginJourney = 'Begin Your Journey';

  // ─── Login ─────────────────────────────────────────────
  static const String login = 'Login';
  static const String signUp = 'Sign Up';
  static const String email = 'Email';
  static const String password = 'Password';
  static const String confirmPassword = 'Confirm Password';
  static const String fullName = 'Full Name';
  static const String forgotPassword = 'Forgot password?';
  static const String continueWithGoogle = 'Continue with Google';
  static const String or = 'OR';
  static const String dontHaveAccount = "Don't have an account? ";
  static const String alreadyHaveAccount = 'Already have an account? ';
  static const String createAccount = 'Create Account';
  static const String joinSanctuary =
      'Join our sanctuary of mindfulness and spiritual growth.';

  // ─── Home ──────────────────────────────────────────────
  static const String assalamuAlaykum = 'السلام عليكم';
  static const String needHelp = 'NEED HELP?';
  /// Panic button label (home).
  static const String panicLabel = 'PANIC';
  static const String dailyPaths = 'Daily Paths';
  static const String breathe = 'Breathe';
  static const String grief = 'Grief';
  /// Shell nav label for the main dashboard (`/home`).
  static const String home = 'Home';
  static const String sanctuary = 'Sanctuary';
  static const String profile = 'Profile';
  static const String audioLibrary = 'Audio Library';
  static const String nowPlaying = 'Now Playing';
  static const String streakScreenTitle = 'Daily streak';
  static const String streakDaysLabel = 'DAY STREAK';
  static const String streakEncouragement =
      'Every day you return, your heart grows steadier. Keep going.';
  static const String streakHeroEyebrow = 'KEEP THE FLAME ALIVE';
  static const String streakHeroSubtitle = 'You showed up. That matters.';
  static const String streakThisWeek = 'This week';
  static const String streakNextMilestone = 'Next glow-up · 14 days';

  // ─── Quran quote (home) ────────────────────────────────
  static const String quranArabicHome = 'فَإِنَّ مَعَ الْعُسْرِ يُسْرًا';
  static const String quranEnglishHome =
      '"For indeed, with hardship [will be] ease."';
  static const String quranSubtitleHome =
      'Find instant calm in moments of distress';

  // ─── How are you feeling? ──────────────────────────────
  static const String howAreYouFeeling = 'How are you feeling?';
  static const String checkInWithHeart = 'CHECK-IN WITH YOUR HEART';
  static const String good = 'Good';
  static const String notGood = 'Not Good';
  static const String peacefulBalanced = 'Peaceful & Balanced';
  static const String restlessHeavy = 'Restless or Heavy';
  static const String takeABreath = 'TAKE A BREATH';

  /// After choosing a mood — pick Quranic ayahs or English quotes.
  static const String moodChooseContentTitle = 'What would you like to read?';
  static const String moodChooseContentSubtitle = 'Choose ayahs or gentle quotes';
  static const String moodContentAyahsLabel = 'Ayahs';
  static const String moodContentAyahsSubtitle = 'Quranic verses with reflection';
  static const String moodContentQuotesLabel = 'Quotes';
  static const String moodContentQuotesSubtitle = 'English words for your heart';
  static const String moodQuotesCarouselTitle = 'Words for you';

  /// English-only cards when user picks Quotes after a positive mood check-in.
  static const List<Map<String, String>> moodPositiveEnglishQuotes = [
    {
      'quote': 'Gratitude turns what we have into enough.',
      'reflection': 'Let this moment count.',
    },
    {
      'quote': 'Small steps still move you forward.',
      'reflection': 'Progress is not always visible.',
    },
    {
      'quote': 'Peace begins when expectation ends.',
      'reflection': 'Breathe and release what you cannot control.',
    },
    {
      'quote': 'You are allowed to rest without earning it.',
      'reflection': 'Your worth is not measured by output.',
    },
    {
      'quote': 'Light finds the cracks.',
      'reflection': 'What feels broken may still let love in.',
    },
  ];

  /// English-only cards when user picks Quotes after a difficult mood check-in.
  static const List<Map<String, String>> moodNegativeEnglishQuotes = [
    {
      'quote': 'This feeling is a visitor, not your home.',
      'reflection': 'It can move through you.',
    },
    {
      'quote': 'You do not have to carry today alone.',
      'reflection': 'Asking for help is courage.',
    },
    {
      'quote': 'Healing is not linear; be gentle with the spiral.',
      'reflection': 'Some days are for surviving, not thriving.',
    },
    {
      'quote': 'What hurts can also soften you.',
      'reflection': 'Tenderness often follows the storm.',
    },
    {
      'quote': 'Nothing lasts, not even this heaviness.',
      'reflection': 'The next breath is a new chance.',
    },
  ];

  // ─── Ayah Carousel ─────────────────────────────────────
  static const List<Map<String, String>> ayahs = [
    {
      'arabic': 'فَبِأَيِّ آلَاءِ رَبِّكُمَا تُكَذِّبَانِ',
      'english': '"So which of the favors of your Lord would you deny?"',
      'reflection': 'Gratitude is the heart\'s memory.',
    },
    {
      'arabic': 'إِنَّ مَعَ الْعُسْرِ يُسْرًا',
      'english': '"Verily, with hardship comes ease."',
      'reflection': 'This too shall pass.',
    },
    {
      'arabic': 'وَهُوَ مَعَكُمْ أَيْنَ مَا كُنتُمْ',
      'english': '"And He is with you wherever you are."',
      'reflection': 'You are never alone.',
    },
    {
      'arabic': 'أَلَا بِذِكْرِ اللَّهِ تَطْمَئِنُّ الْقُلُوبُ',
      'english':
      '"Unquestionably, by the remembrance of Allah hearts find rest."',
      'reflection': 'Peace starts within.',
    },
    {
      'arabic': 'وَتَوَكَّلْ عَلَى الْحَيِّ الَّذِي لَا يَمُوتُ',
      'english': '"And rely upon the Ever-Living who does not die."',
      'reflection': 'Anchor yourself in the Infinite.',
    },
  ];

  // ─── Supportive Ayah ───────────────────────────────────
  static const String findPeaceInHisWords = 'Find Peace in His Words';
  static const String dailySolaceEyebrow = 'DAILY SOLACE';
  static const String supportiveAyahExhaustedPrompt = 'SO MUCH EXHAUSTED?';
  static const String needFurtherSupportButton = 'Need further support';
  static const String stillNotFeeling = 'Still not feeling better?';
  static const String itsOkay =
      "It's okay to take your time. Would you like to try something else?";
  static const String needFurtherSupport = 'Need Further Support?';

  /// Further support hub (`/mood-further-support`) — title + cards.
  static const String moodFurtherSupportTitle = 'Support';
  static const String supportHubFooter = 'Choose what helps you feel better';
  static const String supportCategoryReflection = 'REFLECTION';
  static const String supportCardQuotesTitle = 'Continue Reading Quotes';
  static const String supportCardQuotesSubtitle =
      'Timeless wisdom for the quiet soul.';
  static const String supportCategoryPractice = 'PRACTICE';
  static const String supportCardBreatheTitle = 'Try Breathing';
  static const String supportCardBreatheSubtitle =
      'Regulate your rhythm with the divine breath.';
  static const String supportCategoryConnection = 'CONNECTION';
  static const String supportCardCallTitle = 'Call a Friend';
  static const String supportCardCallSubtitle =
      'Reach out to a soul who understands.';
  static const String supportCallFriendHint =
      'Reach out to someone you trust — you are not alone.';

  static const List<Map<String, String>> supportiveAyahs = [
    {
      'arabic': 'فَإِنَّ مَعَ الْعُسْرِ يُسْرًا',
      'english': '"For indeed, with hardship [will be] ease."',
      'reflection': 'Allah does not burden a soul beyond that it can bear.',
    },
    {
      'arabic': 'أَلَا بِذِكْرِ اللَّهِ تَطْمَئِنُّ الْقُلُوبُ',
      'english':
      '"Unquestionably, by the remembrance of Allah hearts are assured."',
      'reflection': 'He knows the silent prayer of your tired heart.',
    },
    {
      'arabic': 'وَقَالَ رَبُّكُمُ ادْعُونِي أَسْتَجِبْ لَكُمْ',
      'english': '"Call upon Me; I will respond to you."',
      'reflection': 'You are never truly alone in your struggles.',
    },
    {
      'arabic': 'إِنَّ اللَّهَ مَعَ الصَّابِرِينَ',
      'english': '"Indeed, Allah is with the patient."',
      'reflection': 'Your patience is never lost in His sight.',
    },
    {
      'arabic': 'وَرَحْمَتِي وَسِعَتْ كُلَّ شَيْءٍ',
      'english': '"My mercy encompasses all things."',
      'reflection': 'Let His mercy be the anchor of your soul today.',
    },
  ];

  // ─── Breathe / Dhikr ───────────────────────────────────
  static const String sessionInProgress = 'Session In Progress';
  static const String peacefulMorning = 'Peaceful Morning';
  static const String subhanAllah = 'SubhanAllah';
  static const String gloryBeToAllah = 'Glory be to Allah';
  static const String endSession = 'End Session';
  static const String serenity = 'Serenity';
  static const String presence = 'Presence';
  static const String sessionComplete = 'Session Complete';
  static const String breathInLabel = 'Breath in';
  static const String breathHoldLabel = 'Hold';
  static const String breathOutLabel = 'Breath out';
  static const String alhamdulillah = 'Alhamdulillah';
  static const String allahuAkbar = 'Allahu Akbar';
  static const String breatheChangeWord = 'Change word';

  /// Breathe setup (`/breathe`) — technique picker UI.
  static const String breatheSetupSubtitle =
      'Select a technique to harmonize your soul and quiet the mind.';
  static const String breatheSelectTechnique = 'SELECT TECHNIQUE';
  static const String breatheTechniqueBox = 'Box Breathing';
  static const String breatheTechniqueBoxSub = '4-4-4 Technique';
  static const String breatheTechnique478 = '4-7-8 Relaxation';
  static const String breatheTechnique478Sub = 'Deep Sleep & Calm';
  static const String breatheTechniqueSimple = 'Simple Calm';
  static const String breatheTechniqueSimpleSub = '5-5 Rhythmic Breathing';
  static const String breatheTagFocus = 'FOCUS';
  static const String breatheTagBalance = 'BALANCE';
  static const String breatheDurationLabel = 'DURATION';
  static const String breathePairDhikr = 'Pair with Dhikr';
  static const String breathePairDhikrSub =
      "Reciting 'SubhanAllah' on exhale";
  static const String breatheBeginPractice = 'Begin Practice';

  /// Dhikr counter (`/dhikr`) — home Daily Paths.
  static const String dhikrScreenTitle = 'Dhikr';
  static const String dhikrScreenSubtitle =
      'Complete each phrase with calm, mindful taps.';
  static const String dhikrTapCircle = 'Tap the circle to count';
  static const String dhikrTapToCount = 'Increment dhikr count';
  static const String dhikrRoundComplete = 'Round complete';
  static const String dhikrRoundCompleteSub =
      'Allahu Akbar × 34, Alhamdulillah × 33, SubhanAllah × 33.';
  static const String dhikrReset = 'Reset';
  static const String dhikrStartAgain = 'Start again';

  static String dhikrPhaseNofM(int n, int m) => 'Phase $n of $m';

  // ─── Grief Burner ──────────────────────────────────────
  static const String griefBurner = 'Grief Burner';
  static const String weightOfUnspoken =
      'The weight of unspoken goodbyes...';
  static const String releaseComplete = 'Release complete';
  static const String postBurnArabic = 'وَهُوَ السَّمِيعُ الْعَلِيمُ';
  static const String postBurnEnglish =
      "'He is the All-Hearing, the All-Knowing.'";
  static const String postBurnReference = 'Surah Al-Baqarah 137';

  // ─── Milestone ─────────────────────────────────────────
  static const String milestoneCongrats = 'MashaAllah, 100 days of calm.';
  static const String milestoneSubtitle =
      'Spirituality • Consistency • Peace';
  static const String milestoneQuote =
      '"Through patience and perseverance, the soul finds its rhythm in the divine decree."';

  // ─── Profile ───────────────────────────────────────────
  static const String profileName = 'Tasha';
  static const String soulInTraining = 'Soul in training';
  static const String totalTime = '42h 15m';
  static const String versesRead = '312';
  static const String spiritualGrowth = 'Spiritual Growth';
  static const String topCommunity =
      "You're in the top 5% of your community this week.";
  static const String modePreference = 'Mode Preference';
  static const String appearance = 'Appearance';
  static const String themeLight = 'Light';
  static const String themeDark = 'Dark';
  static const String themeSystem = 'System';

  // ─── Premium ───────────────────────────────────────────
  static const String upgradeToPremium = 'Upgrade to Premium';
  static const String experienceSpiritualDepth = 'Experience Spiritual Depth';
  static const String premiumDescription =
      'Unlock the full sanctuary experience and nourish your soul with premium guided sessions.';
  static const String monthlyPlan = 'Monthly Plan';
  static const String yearlyPlan = 'Yearly Plan';
  static const String monthlyDesc =
      'Full access to Dhikr, Breathing, Grief Burner & Premium Quotes.';
  static const String yearlyDesc =
      'Save 33%, unlock all premium features and future sanctuary updates.';

  // ─── Support ───────────────────────────────────────────
  static const String supportOptions = 'Support Options';

  // ─── Legal (drawer) ────────────────────────────────────
  static const String privacyPolicy = 'Privacy Policy';
  static const String termsAndConditions = 'Terms & Conditions';
  static const String legalLastUpdated = 'Last updated: April 2026';

  // ─── Shell navigation (drawer + current screen label) ──
  static const String navAyahs = 'Ayahs';
  static const String navGuidedBreathe = 'Guided breathe';
  static const String navMilestones = 'Milestones';
  static const String navMindfulness = 'Mindfulness';
}


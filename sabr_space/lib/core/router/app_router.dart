import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:sabr_space/core/constants/app_spacing.dart';
import 'package:sabr_space/core/constants/app_strings.dart';
import 'package:sabr_space/core/theme/app_gradients.dart';
import 'package:sabr_space/core/theme/theme_palette.dart';

import 'package:sabr_space/features/home/presentation/screens/home_screen/home_screen.dart';
import 'package:sabr_space/features/home/presentation/models/mood_quotes_args.dart';
import 'package:sabr_space/features/home/presentation/screens/mood_check_screen/mood_check_screen.dart';
import 'package:sabr_space/features/home/presentation/screens/mood_quotes_carousel_screen/mood_quotes_carousel_screen.dart';
import 'package:sabr_space/features/home/presentation/screens/streak_screen/streak_screen.dart';
import 'package:sabr_space/features/intro/presentation/screens/intro_screen/intro_screen.dart';
import 'package:sabr_space/features/intro/presentation/screens/login_screen/login_screen.dart';
import 'package:sabr_space/features/intro/presentation/screens/signup_screen/signup_screen.dart';
import 'package:sabr_space/features/profile/presentation/screens/premium_screen/premium_screen.dart';
import 'package:sabr_space/features/profile/presentation/screens/profile_screen/profile_screen.dart';
import 'package:sabr_space/features/profile/presentation/screens/privacy_policy_screen/privacy_policy_screen.dart';
import 'package:sabr_space/features/profile/presentation/screens/support_options_screen/support_options_screen.dart';
import 'package:sabr_space/features/profile/presentation/screens/terms_conditions_screen/terms_conditions_screen.dart';
import 'package:sabr_space/features/sanctuary/presentation/screens/ayah_carousel_screen/ayah_carousel_screen.dart';
import 'package:sabr_space/features/sanctuary/presentation/screens/breathe_completion_screen/breathe_completion_screen.dart';
import 'package:sabr_space/features/sanctuary/presentation/models/breathe_session_args.dart';
import 'package:sabr_space/features/sanctuary/presentation/screens/breathe_minimal_screen/breathe_minimal_screen.dart';
import 'package:sabr_space/features/sanctuary/presentation/screens/breathe_session_screen/breathe_session_screen.dart';
import 'package:sabr_space/features/sanctuary/presentation/screens/grief_burn_screen/grief_burn_screen.dart';
import 'package:sabr_space/features/sanctuary/presentation/screens/grief_completion_screen/grief_completion_screen.dart';
import 'package:sabr_space/features/sanctuary/presentation/screens/grief_writing_screen/grief_writing_screen.dart';
import 'package:sabr_space/features/sanctuary/presentation/screens/milestone_screen/milestone_screen.dart';
import 'package:sabr_space/features/sanctuary/presentation/screens/mindfulness_screen/mindfulness_screen.dart';
import 'package:sabr_space/features/sanctuary/presentation/screens/supportive_ayah_screen/supportive_ayah_screen.dart';
import 'package:sabr_space/features/sanctuary/presentation/screens/supportive_ayah_screen/supportive_ayah_verses_screen.dart';
import 'package:sabr_space/features/sanctuary/presentation/screens/zikr_counter_screen/zikr_counter_screen.dart';
import 'package:sabr_space/features/journal/presentation/screens/journal_history_screen/journal_history_screen.dart';
import 'package:sabr_space/features/journal/presentation/screens/mood_selection_screen/mood_selection_screen.dart';
import 'package:sabr_space/features/journal/presentation/screens/journal_entry_screen/journal_entry_screen.dart';
import 'package:sabr_space/features/journal/presentation/screens/journal_detail_screen/journal_detail_screen.dart';
import 'package:sabr_space/features/audio/presentation/models/audio_player_args.dart';
import 'package:sabr_space/features/audio/presentation/screens/audio_library_screen.dart';
import 'package:sabr_space/features/audio/presentation/screens/audio_player_screen.dart';

final GlobalKey<ScaffoldState> _shellScaffoldKey = GlobalKey<ScaffoldState>();

String _shellTitleForPath(String path) {
  switch (path) {
    case '/home':
      return AppStrings.home;
    case '/streak':
      return AppStrings.streakScreenTitle;
    case '/mood-check':
      return AppStrings.howAreYouFeeling;
    case '/mood-quotes':
      return AppStrings.moodQuotesCarouselTitle;
    case '/ayah-carousel':
      return AppStrings.navAyahs;
    case '/supportive-ayah':
      return AppStrings.findPeaceInHisWords;
    case '/mood-further-support':
      return AppStrings.moodFurtherSupportTitle;
    case '/breathe':
      return AppStrings.breathe;
    case '/dhikr':
      return AppStrings.dhikrScreenTitle;
    case '/breathe-session':
      return AppStrings.sessionInProgress;
    case '/breathe-complete':
      return AppStrings.sessionComplete;
    case '/grief-write':
      return AppStrings.grief;
    case '/grief-burn':
      return AppStrings.griefBurner;
    case '/journal':
      return 'Journal';
    case '/grief-complete':
      return AppStrings.releaseComplete;
    case '/milestone':
      return AppStrings.navMilestones;
    case '/mindfulness':
      return AppStrings.navMindfulness;
    case '/profile':
      return AppStrings.profile;
    case '/support':
      return AppStrings.supportOptions;
    case '/premium':
      return AppStrings.upgradeToPremium;
    case '/privacy-policy':
      return AppStrings.privacyPolicy;
    case '/terms-conditions':
      return AppStrings.termsAndConditions;
    case '/audio-library':
      return AppStrings.audioLibrary;
    case '/audio-player':
      return AppStrings.nowPlaying;
    default:
      return AppStrings.appName;
  }
}

IconData _shellIconForPath(String path) {
  switch (path) {
    case '/home':
      return Icons.home_max_rounded;
    case '/streak':
      return Icons.local_fire_department_rounded;
    case '/mood-check':
      return Icons.favorite_rounded;
    case '/mood-quotes':
      return Icons.format_quote_rounded;
    case '/ayah-carousel':
      return Icons.auto_stories_rounded;
    case '/supportive-ayah':
      return Icons.wb_sunny_rounded;
    case '/mood-further-support':
      return Icons.volunteer_activism_rounded;
    case '/breathe':
      return Icons.air_rounded;
    case '/dhikr':
      return Icons.self_improvement_rounded;
    case '/breathe-session':
      return Icons.self_improvement_rounded;
    case '/breathe-complete':
      return Icons.air_rounded;
    case '/grief-write':
      return Icons.local_fire_department_rounded;
    case '/grief-burn':
      return Icons.whatshot_rounded;
    case '/journal':
      return Icons.book_rounded;
    case '/grief-complete':
      return Icons.check_circle_rounded;
    case '/milestone':
      return Icons.emoji_events_rounded;
    case '/mindfulness':
      return Icons.spa_rounded;
    case '/profile':
      return Icons.person_rounded;
    case '/support':
      return Icons.help_outline_rounded;
    case '/premium':
      return Icons.workspace_premium_rounded;
    case '/privacy-policy':
      return Icons.privacy_tip_rounded;
    case '/terms-conditions':
      return Icons.article_rounded;
    case '/audio-library':
      return Icons.library_music_rounded;
    case '/audio-player':
      return Icons.headphones_rounded;
    default:
      return Icons.space_dashboard_rounded;
  }
}

void _goFromDrawer(BuildContext context, String location) {
  context.go(location);
  Navigator.of(context).pop();
}

class _AppDrawer extends StatelessWidget {
  const _AppDrawer({required this.currentPath});

  final String currentPath;

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    final text = context.text;
    return Drawer(
      backgroundColor: palette.surface,
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: BoxDecoration(
              gradient: AppGradients.primaryGradient(context),
            ),
            margin: EdgeInsets.zero,
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.xxl,
              AppSpacing.xxl,
              AppSpacing.xxl,
              AppSpacing.lg,
            ),
            child: Align(
              alignment: Alignment.bottomLeft,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    AppStrings.appName,
                    style: text.headlineSmall?.copyWith(
                      color: palette.onPrimary,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xs),
                  Text(
                    AppStrings.tagline,
                    style: text.bodySmall?.copyWith(
                      color: palette.onPrimary.withValues(alpha: 0.85),
                    ),
                  ),
                ],
              ),
            ),
          ),
          _drawerTile(
            context,
            icon: Icons.home_max_outlined,
            label: AppStrings.home,
            path: '/home',
          ),
          _drawerTile(
            context,
            icon: Icons.local_fire_department_outlined,
            label: AppStrings.grief,
            path: '/grief-write',
          ),
          _drawerTile(
            context,
            icon: Icons.air_outlined,
            label: AppStrings.breathe,
            path: '/breathe',
          ),
          _drawerTile(
            context,
            icon: Icons.self_improvement_outlined,
            label: AppStrings.dhikrScreenTitle,
            path: '/dhikr',
          ),
          _drawerTile(
            context,
            icon: Icons.book_outlined,
            label: 'Journal',
            path: '/journal',
          ),
          _drawerTile(
            context,
            icon: Icons.library_music_outlined,
            label: AppStrings.audioLibrary,
            path: '/audio-library',
          ),
          _drawerTile(
            context,
            icon: Icons.person_outline,
            label: AppStrings.profile,
            path: '/profile',
          ),
          const Divider(height: 1),
          _drawerTile(
            context,
            icon: Icons.privacy_tip_outlined,
            label: AppStrings.privacyPolicy,
            path: '/privacy-policy',
          ),
          _drawerTile(
            context,
            icon: Icons.description_outlined,
            label: AppStrings.termsAndConditions,
            path: '/terms-conditions',
          ),
        ],
      ),
    );
  }

  Widget _drawerTile(
    BuildContext context, {
    required IconData icon,
    required String label,
    required String path,
  }) {
    final palette = context.palette;
    final text = context.text;
    final selected = currentPath == path;
    return ListTile(
      leading: Icon(
        icon,
        color: selected ? palette.primary : palette.onSurfaceVariant,
      ),
      title: Text(
        label,
        style: text.titleSmall?.copyWith(
          color: selected ? palette.primary : palette.onSurface,
          fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
        ),
      ),
      selected: selected,
      selectedTileColor: palette.primaryFixed.withValues(alpha: 0.45),
      onTap: () => _goFromDrawer(context, path),
    );
  }
}

/// Shell: menu (bottom-left), bottom bar icon. Back lives on each screen via [ScreenBackButton].
class _MainShell extends StatelessWidget {
  const _MainShell({required this.child, required this.routerState});

  final Widget child;
  final GoRouterState routerState;

  static const double _shellBottomInsetForMenu = 56;

  @override
  Widget build(BuildContext context) {
    final path = routerState.uri.path;
    final palette = context.palette;

    return Scaffold(
      key: _shellScaffoldKey,
      drawer: _AppDrawer(currentPath: path),
      body: Stack(
        fit: StackFit.expand,
        clipBehavior: Clip.none,
        children: [
          Positioned.fill(
            child: Padding(
              padding: const EdgeInsets.only(bottom: _shellBottomInsetForMenu),
              child: child,
            ),
          ),
          Positioned(
            left: AppSpacing.sm,
            bottom: AppSpacing.sm,
            child: SafeArea(
              top: false,
              child: Tooltip(
                message: 'Menu',
                child: Material(
                  color: palette.surface,
                  elevation: 2,
                  shadowColor: palette.onSurface.withValues(alpha: 0.12),
                  shape: const CircleBorder(),
                  clipBehavior: Clip.antiAlias,
                  child: InkWell(
                    customBorder: const CircleBorder(),
                    onTap: () =>
                        _shellScaffoldKey.currentState?.openDrawer(),
                    child: Padding(
                      padding: const EdgeInsets.all(10),
                      child: Icon(
                        Icons.menu_rounded,
                        size: 24,
                        color: palette.primary,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: Material(
        elevation: 8,
        shadowColor: palette.onSurface.withValues(alpha: 0.08),
        color: palette.surface,
        child: SafeArea(
          child: SizedBox(
            height: 56,
            child: Center(
              child: Semantics(
                label: _shellTitleForPath(path),
                header: true,
                child: Icon(
                  _shellIconForPath(path),
                  size: 28,
                  color: palette.primary,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Application router using go_router.
final GoRouter appRouter = GoRouter(
  initialLocation: '/',
  routes: [
    // ── Auth flow (no bottom nav) ──
    GoRoute(path: '/', builder: (context, state) => const IntroScreen()),
    GoRoute(path: '/login', builder: (context, state) => const LoginScreen()),
    GoRoute(path: '/signup', builder: (context, state) => const SignUpScreen()),

    // ── Shell routes (floating menu + bottom bar icon, drawer for tabs) ──
    ShellRoute(
      builder: (context, state, child) {
        return _MainShell(routerState: state, child: child);
      },
      routes: [
        // Home
        GoRoute(path: '/home', builder: (context, state) => const HomeScreen()),

        GoRoute(
          path: '/streak',
          builder: (context, state) => const StreakScreen(),
        ),

        // Mood check
        GoRoute(
          path: '/mood-check',
          builder: (context, state) => const MoodCheckScreen(),
        ),

        // Mood — English quotes carousel (after check-in)
        GoRoute(
          path: '/mood-quotes',
          builder: (context, state) {
            final extra = state.extra;
            final args = extra is MoodQuotesArgs
                ? extra
                : MoodQuotesArgs.defaultPositive;
            return MoodQuotesCarouselScreen(args: args);
          },
        ),

        // Ayah carousel
        GoRoute(
          path: '/ayah-carousel',
          builder: (context, state) => const AyahCarouselScreen(),
        ),

        // Supportive ayah verses → further support hub
        GoRoute(
          path: '/supportive-ayah',
          builder: (context, state) => const SupportiveAyahVersesScreen(),
        ),
        GoRoute(
          path: '/mood-further-support',
          builder: (context, state) => const MoodFurtherSupportScreen(),
        ),

        // Breathe — minimal
        GoRoute(
          path: '/breathe',
          builder: (context, state) => const BreatheMinimalScreen(),
        ),

        GoRoute(
          path: '/dhikr',
          builder: (context, state) => const ZikrCounterScreen(),
        ),

        // Breathe — full session
        GoRoute(
          path: '/breathe-session',
          builder: (context, state) {
            final extra = state.extra;
            final args = extra is BreatheSessionArgs
                ? extra
                : BreatheSessionArgs.defaultArgs;
            return BreatheSessionScreen(args: args);
          },
        ),

        // Breathe — completion
        GoRoute(
          path: '/breathe-complete',
          builder: (context, state) => const BreatheCompletionScreen(),
        ),

        // Grief — writing
        GoRoute(
          path: '/grief-write',
          builder: (context, state) => const GriefWritingScreen(),
        ),

        // Grief — burn
        GoRoute(
          path: '/grief-burn',
          builder: (context, state) => const GriefBurnScreen(),
        ),

        // Grief — completion
        GoRoute(
          path: '/grief-complete',
          builder: (context, state) => const GriefCompletionScreen(),
        ),

        // Milestone
        GoRoute(
          path: '/milestone',
          builder: (context, state) => const MilestoneScreen(),
        ),

        // Mindfulness
        GoRoute(
          path: '/mindfulness',
          builder: (context, state) => const MindfulnessScreen(),
        ),

        // Profile
        GoRoute(
          path: '/profile',
          builder: (context, state) => const ProfileScreen(),
        ),

        // Support
        GoRoute(
          path: '/support',
          builder: (context, state) => const SupportOptionsScreen(),
        ),

        // Premium
        GoRoute(
          path: '/premium',
          builder: (context, state) => const PremiumScreen(),
        ),

        // Legal
        GoRoute(
          path: '/privacy-policy',
          builder: (context, state) => const PrivacyPolicyScreen(),
        ),
        GoRoute(
          path: '/terms-conditions',
          builder: (context, state) => const TermsConditionsScreen(),
        ),

        // Audio library & player
        GoRoute(
          path: '/audio-library',
          builder: (context, state) => const AudioLibraryScreen(),
        ),
        GoRoute(
          path: '/audio-player',
          builder: (context, state) {
            final extra = state.extra;
            final args = extra is AudioPlayerArgs
                ? extra
                : AudioPlayerArgs.featured();
            return AudioPlayerScreen(args: args);
          },
        ),

        // ── Journal ──────────────────────────────────────────
        // Journal history (main list)
        GoRoute(
          path: '/journal',
          builder: (context, state) => const JournalHistoryScreen(),
        ),

        // Journal — mood selection (new entry flow step 1)
        GoRoute(
          path: '/journal/mood',
          builder: (context, state) => const MoodSelectionScreen(),
        ),

        // Journal — entry writing (new entry flow step 2)
        GoRoute(
          path: '/journal/entry',
          builder: (context, state) {
            final moods = state.uri.queryParameters['moods'] ?? '';
            return JournalEntryScreen(moodIndices: moods);
          },
        ),

        // Journal — detail view
        GoRoute(
          path: '/journal/detail/:id',
          builder: (context, state) {
            final id = state.pathParameters['id'] ?? '';
            return JournalDetailScreen(entryId: id);
          },
        ),
      ],
    ),
  ],
);

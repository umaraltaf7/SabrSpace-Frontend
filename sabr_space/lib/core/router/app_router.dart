import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:sabr_space/core/constants/app_spacing.dart';
import 'package:sabr_space/core/constants/app_strings.dart';
import 'package:sabr_space/core/theme/theme_palette.dart';
import 'package:sabr_space/features/intro/presentation/widgets/sanctuary_logo.dart';

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
import 'package:sabr_space/features/journal/presentation/screens/journal_multistep_write_screen/journal_multistep_write_screen.dart';
import 'package:sabr_space/features/journal/presentation/screens/journal_reward_screen/journal_reward_screen.dart';
import 'package:sabr_space/features/journal/presentation/screens/journal_voice_premium_gate_screen/journal_voice_premium_gate_screen.dart';
import 'package:sabr_space/features/journal/presentation/screens/journal_detail_screen/journal_detail_screen.dart';
import 'package:sabr_space/features/audio/presentation/models/audio_player_args.dart';
import 'package:sabr_space/features/audio/presentation/screens/audio_library_screen.dart';
import 'package:sabr_space/features/audio/presentation/screens/audio_player_screen.dart';
import 'package:sabr_space/features/visualize/presentation/models/visualize_track.dart';
import 'package:sabr_space/features/visualize/presentation/screens/visualize_screen/visualize_screen.dart';
import 'package:sabr_space/features/visualize/presentation/screens/visualize_player_screen/visualize_player_screen.dart';
import 'package:sabr_space/features/quran/presentation/screens/quran_screen/quran_screen.dart';

final GlobalKey<ScaffoldState> _shellScaffoldKey = GlobalKey<ScaffoldState>();

void _goFromDrawer(BuildContext context, String location) {
  context.go(location);
  Navigator.of(context).pop();
}

class _AppDrawer extends StatelessWidget {
  const _AppDrawer({required this.currentPath});

  final String currentPath;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final text = context.text;

    return Drawer(
      backgroundColor: isDark
          ? const Color(0xFF32143E)
          : Colors.white,
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Color(0xFF6B2FA0), Color(0xFF9B4DC8)],
              ),
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
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SanctuaryLogo(size: 48, showDropShadow: false),
                  const SizedBox(width: AppSpacing.md),
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        AppStrings.appName,
                        style: text.headlineSmall?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: AppSpacing.xs),
                      Text(
                        AppStrings.tagline,
                        style: text.bodySmall?.copyWith(
                          color: Colors.white.withOpacity(0.85),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          _drawerTile(
            context,
            isDark: isDark,
            icon: Icons.home_max_outlined,
            label: AppStrings.home,
            path: '/home',
          ),
          _drawerTile(
            context,
            isDark: isDark,
            icon: Icons.menu_book_outlined,
            label: 'Qur\'an',
            path: '/quran',
          ),
          _drawerTile(
            context,
            isDark: isDark,
            icon: Icons.local_fire_department_outlined,
            label: AppStrings.grief,
            path: '/grief-write',
          ),
          _drawerTile(
            context,
            isDark: isDark,
            icon: Icons.air_outlined,
            label: AppStrings.breathe,
            path: '/breathe',
          ),
          _drawerTile(
            context,
            isDark: isDark,
            icon: Icons.self_improvement_outlined,
            label: AppStrings.dhikrScreenTitle,
            path: '/dhikr',
          ),
          _drawerTile(
            context,
            isDark: isDark,
            icon: Icons.book_outlined,
            label: 'Journal',
            path: '/journal',
          ),
          _drawerTile(
            context,
            isDark: isDark,
            icon: Icons.visibility_outlined,
            label: 'Visualize',
            path: '/visualize',
          ),
          _drawerTile(
            context,
            isDark: isDark,
            icon: Icons.library_music_outlined,
            label: AppStrings.audioLibrary,
            path: '/audio-library',
          ),
          _drawerTile(
            context,
            isDark: isDark,
            icon: Icons.person_outline,
            label: AppStrings.profile,
            path: '/profile',
          ),
          Divider(
            height: 1,
            color: isDark
                ? const Color(0xFFCC98E7).withOpacity(0.15)
                : const Color(0xFFBC95D8).withOpacity(0.40),
          ),
          _drawerTile(
            context,
            isDark: isDark,
            icon: Icons.privacy_tip_outlined,
            label: AppStrings.privacyPolicy,
            path: '/privacy-policy',
          ),
          _drawerTile(
            context,
            isDark: isDark,
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
    required bool isDark,
    required IconData icon,
    required String label,
    required String path,
  }) {
    final text = context.text;
    final selected = currentPath == path;

    final activeColor = isDark
        ? const Color(0xFFBC80DE)
        : const Color(0xFF6E35A3);
    final inactiveIconColor = isDark
        ? const Color(0xFFE8D4F4).withOpacity(0.6)
        : const Color(0xFF7C57A0);
    final inactiveTextColor = isDark
        ? const Color(0xFFF4EAFB)
        : const Color(0xFF3D274E);

    return ListTile(
      leading: Icon(
        icon,
        color: selected ? activeColor : inactiveIconColor,
      ),
      title: Text(
        label,
        style: text.titleSmall?.copyWith(
          color: selected ? activeColor : inactiveTextColor,
          fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
        ),
      ),
      selected: selected,
      selectedTileColor: isDark
          ? const Color(0xFF46275E).withOpacity(0.6)
          : const Color(0xFFE0C9F0).withOpacity(0.5),
      onTap: () => _goFromDrawer(context, path),
    );
  }
}

/// Shell: 4-item bottom nav with drawer access on "More".
class _MainShell extends StatelessWidget {
  const _MainShell({required this.child, required this.routerState});

  final Widget child;
  final GoRouterState routerState;

  @override
  Widget build(BuildContext context) {
    final path = routerState.uri.path;
    final palette = context.palette;
    final items = const <_ShellNavItem>[
      _ShellNavItem(
        label: 'Home',
        icon: Icons.home_filled,
        route: '/home',
      ),
      _ShellNavItem(
        label: 'Quran',
        icon: Icons.menu_book_rounded,
        route: '/quran',
      ),
      _ShellNavItem(
        label: 'Self',
        icon: Icons.person_rounded,
      ),
      _ShellNavItem(
        label: 'More',
        icon: Icons.more_horiz_rounded,
      ),
    ];
    final selectedIndex = _selectedShellIndex(path);

    return Scaffold(
      key: _shellScaffoldKey,
      drawer: _AppDrawer(currentPath: path),
      body: child,
      bottomNavigationBar: Material(
        elevation: 8,
        shadowColor: palette.onSurface.withValues(alpha: 0.08),
        color: palette.surface,
        child: SafeArea(
          child: SizedBox(
            height: 74,
            child: Row(
              children: List.generate(items.length, (index) {
                final item = items[index];
                final selected = index == selectedIndex;
                final color = selected ? palette.primary : palette.onSurfaceVariant;
                return Expanded(
                  child: InkWell(
                    onTap: () {
                      if (item.route == null) {
                        _shellScaffoldKey.currentState?.openDrawer();
                        return;
                      }
                      if (path != item.route) {
                        context.go(item.route!);
                      }
                    },
                    child: Padding(
                      padding: const EdgeInsets.only(top: AppSpacing.sm),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(item.icon, color: color, size: 24),
                          const SizedBox(height: 4),
                          Text(
                            item.label,
                            style: context.text.labelSmall?.copyWith(
                              color: color,
                              fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              }),
            ),
          ),
        ),
      ),
    );
  }
}

int _selectedShellIndex(String path) {
  if (path == '/home') return 0;
  if (path == '/quran') return 1;
  return 3;
}

class _ShellNavItem {
  final String label;
  final IconData icon;
  final String? route;

  const _ShellNavItem({
    required this.label,
    required this.icon,
    this.route,
  });
}

/// Application router using go_router.
final GoRouter appRouter = GoRouter(
  initialLocation: '/',
  routes: [
    // ── Auth flow (no bottom nav) ──
    GoRoute(path: '/', builder: (context, state) => const IntroScreen()),
    GoRoute(path: '/login', builder: (context, state) => const LoginScreen()),
    GoRoute(path: '/signup', builder: (context, state) => const SignUpScreen()),

    // ── Shell routes (bottom nav + drawer on "More") ──
    ShellRoute(
      builder: (context, state, child) {
        return _MainShell(routerState: state, child: child);
      },
      routes: [
        // Home
        GoRoute(path: '/home', builder: (context, state) => const HomeScreen()),

        GoRoute(
          path: '/quran',
          builder: (context, state) => const QuranScreen(),
        ),

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

        // Journal — guided multi-step writing (after mood)
        GoRoute(
          path: '/journal/write',
          builder: (context, state) {
            final moods = state.uri.queryParameters['moods'] ?? '';
            return JournalMultistepWriteScreen(moodIndices: moods);
          },
        ),

        // Journal — voice journaling premium gate
        GoRoute(
          path: '/journal/voice-premium',
          builder: (context, state) =>
              const JournalVoicePremiumGateScreen(),
        ),

        // Journal — completion reward (after guided entry)
        GoRoute(
          path: '/journal/reward',
          builder: (context, state) {
            final extra = state.extra;
            final total = extra is int ? extra : null;
            return JournalRewardScreen(totalPoints: total);
          },
        ),

        // Journal — legacy single-screen entry (deep links)
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

        // ── Visualize ──────────────────────────────────────────
        GoRoute(
          path: '/visualize',
          builder: (context, state) => const VisualizeScreen(),
        ),
        GoRoute(
          path: '/visualize-player',
          builder: (context, state) {
            final extra = state.extra;
            final track = extra is VisualizeTrack
                ? extra
                : VisualizeTrack.tilawatTracks.first;
            return VisualizePlayerScreen(track: track);
          },
        ),
      ],
    ),
  ],
);

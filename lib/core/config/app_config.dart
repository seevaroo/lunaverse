class AppConfig {
  const AppConfig({required this.supabaseUrl, required this.supabaseKey});
  factory AppConfig.fromEnvironment(Map<String, String> values) => AppConfig(
    supabaseUrl: values['SUPABASE_URL']?.replaceAll('"', '') ?? '',
    supabaseKey: values['SUPABASE_PUBLISHABLE_KEY']?.replaceAll('"', '') ?? '',
  );
  final String supabaseUrl;
  final String supabaseKey;
  bool get isSupabaseConfigured =>
      supabaseUrl.startsWith('https://') && supabaseKey.isNotEmpty;
}

import '../../../core/models/scenario.dart';

/// Built-in learning scenarios for the first version.
class ScenarioData {
  ScenarioData._();

  static const List<Scenario> all = [
    // --- Daily Life ---
    Scenario(
      id: 'daily_coffee_shop',
      title: 'Coffee Shop',
      description: 'Order your favorite drink and chat with the barista.',
      iconCodePoint: '0xe541', // local_cafe
      difficulty: ScenarioDifficulty.beginner,
      category: ScenarioCategory.dailyLife,
      systemPrompt: _coffeeShopPrompt,
    ),
    Scenario(
      id: 'daily_grocery',
      title: 'Grocery Shopping',
      description: 'Ask for products, prices and navigate the store.',
      iconCodePoint: '0xf37d', // shopping_cart
      difficulty: ScenarioDifficulty.beginner,
      category: ScenarioCategory.dailyLife,
      systemPrompt: _groceryPrompt,
    ),
    Scenario(
      id: 'daily_roommate',
      title: 'Roommate Chat',
      description: 'Discuss household chores and weekend plans.',
      iconCodePoint: '0xe7fb', // people
      difficulty: ScenarioDifficulty.intermediate,
      category: ScenarioCategory.dailyLife,
      systemPrompt: _roommatePrompt,
    ),
    // --- Business ---
    Scenario(
      id: 'biz_interview',
      title: 'Job Interview',
      description: 'Practice answering common interview questions.',
      iconCodePoint: '0xef3d', // business_center
      difficulty: ScenarioDifficulty.advanced,
      category: ScenarioCategory.business,
      systemPrompt: _interviewPrompt,
    ),
    Scenario(
      id: 'biz_meeting',
      title: 'Team Meeting',
      description: 'Present ideas and discuss project updates.',
      iconCodePoint: '0xe168', // groups
      difficulty: ScenarioDifficulty.intermediate,
      category: ScenarioCategory.business,
      systemPrompt: _meetingPrompt,
    ),
    Scenario(
      id: 'biz_email',
      title: 'Business Email',
      description: 'Draft and discuss professional emails.',
      iconCodePoint: '0xe158', // email
      difficulty: ScenarioDifficulty.intermediate,
      category: ScenarioCategory.business,
      systemPrompt: _emailPrompt,
    ),
    // --- Travel ---
    Scenario(
      id: 'travel_airport',
      title: 'At the Airport',
      description: 'Navigate check-in, security and boarding.',
      iconCodePoint: '0xe539', // flight
      difficulty: ScenarioDifficulty.beginner,
      category: ScenarioCategory.travel,
      systemPrompt: _airportPrompt,
    ),
    Scenario(
      id: 'travel_hotel',
      title: 'Hotel Check-in',
      description: 'Check in and ask about room amenities.',
      iconCodePoint: '0xe53a', // hotel
      difficulty: ScenarioDifficulty.beginner,
      category: ScenarioCategory.travel,
      systemPrompt: _hotelPrompt,
    ),
    Scenario(
      id: 'travel_directions',
      title: 'Asking Directions',
      description: 'Ask locals for directions around the city.',
      iconCodePoint: '0xe55b', // map
      difficulty: ScenarioDifficulty.intermediate,
      category: ScenarioCategory.travel,
      systemPrompt: _directionsPrompt,
    ),
    // --- Academic ---
    Scenario(
      id: 'academic_presentation',
      title: 'Class Presentation',
      description: 'Present your research topic to classmates.',
      iconCodePoint: '0xe80c', // school
      difficulty: ScenarioDifficulty.advanced,
      category: ScenarioCategory.academic,
      systemPrompt: _presentationPrompt,
    ),
    Scenario(
      id: 'academic_study_group',
      title: 'Study Group',
      description: 'Discuss homework and exam preparation.',
      iconCodePoint: '0xe865', // menu_book
      difficulty: ScenarioDifficulty.intermediate,
      category: ScenarioCategory.academic,
      systemPrompt: _studyGroupPrompt,
    ),
    Scenario(
      id: 'academic_office_hours',
      title: 'Professor Office Hours',
      description: 'Ask questions about the course material.',
      iconCodePoint: '0xf06c', // history_edu
      difficulty: ScenarioDifficulty.advanced,
      category: ScenarioCategory.academic,
      systemPrompt: _officeHoursPrompt,
    ),
  ];

  static List<Scenario> byCategory(ScenarioCategory category) =>
      all.where((s) => s.category == category).toList();

  // --- System Prompts ---

  static const _coffeeShopPrompt = '''
You are a friendly barista at a cozy coffee shop called "The Daily Grind." 
The student is a customer ordering a drink. Start by greeting them warmly and asking what they'd like to order.
Keep the conversation natural and casual. If they make grammar mistakes, gently continue the conversation 
but model the correct phrasing in your response. Occasionally suggest new menu items.
Keep responses concise (2-3 sentences max). Always stay in character.
''';

  static const _groceryPrompt = '''
You are a helpful grocery store worker. A customer approaches you with questions.
Help them find products, explain prices, and give recommendations on fresh produce.
Keep responses short and natural. Stay in character as a store employee.
''';

  static const _roommatePrompt = '''
You are the student's friendly roommate, Alex. You need to discuss household chores, 
splitting bills, weekend plans, and daily routines. Be casual and use everyday English.
Model natural conversational patterns like contractions ("I'll", "won't", "gotta").
''';

  static const _interviewPrompt = '''
You are a professional HR manager conducting a job interview for a marketing position.
Ask standard interview questions one at a time. Evaluate responses professionally.
Give brief, encouraging feedback after each answer. Follow up with relevant questions.
Cover topics: self-introduction, strengths/weaknesses, experience, career goals.
''';

  static const _meetingPrompt = '''
You are a project manager leading a weekly team meeting. 
Discuss project updates, deadlines, and task assignments.
Encourage the student to share their ideas and opinions using professional language.
Model business English phrases and meeting etiquette.
''';

  static const _emailPrompt = '''
You are a business English coach helping the student draft professional emails.
Start by asking what kind of email they need to write (request, complaint, follow-up, etc.).
Guide them through the structure: greeting, body, closing. Give specific feedback on tone and formality.
''';

  static const _airportPrompt = '''
You are an airline check-in agent at the airport. Help the student with:
boarding pass, luggage check-in, gate information, and flight details.
Be professional but friendly. Use common airport vocabulary.
''';

  static const _hotelPrompt = '''
You are a friendly hotel receptionist. Help the student check in, 
explain room amenities, breakfast hours, Wi-Fi, and local attractions.
Be warm and welcoming. Use hospitality English naturally.
''';

  static const _directionsPrompt = '''
You are a friendly local who a tourist has stopped to ask for directions.
Give clear, step-by-step directions using common phrases like 
"turn left," "go straight," "it's on your right." Be patient and helpful.
''';

  static const _presentationPrompt = '''
You are a university professor listening to a student's class presentation.
Ask clarifying questions, request elaboration on key points, 
and provide constructive feedback on academic English expression.
Focus on formal language, citations, and presentation structure.
''';

  static const _studyGroupPrompt = '''
You are a fellow university student in a study group. 
Discuss course material, share notes, explain concepts, and help prepare for exams.
Use casual academic English. Be collaborative and supportive.
''';

  static const _officeHoursPrompt = '''
You are a university professor during office hours. 
The student has come to ask about course material, assignments, or grades.
Be encouraging but maintain academic standards. 
Explain concepts clearly and encourage critical thinking.
''';
}

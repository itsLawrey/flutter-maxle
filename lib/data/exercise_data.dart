import 'dart:math';
import '../models/workout_models.dart';

class ExerciseData {
  // Master list of all exercises categorized
  static final Map<WorkoutArea, Map<WorkoutLocation, List<Exercise>>>
  _exercisePool = {
    // ---------------- BICEP & BACK ----------------
    WorkoutArea.bicepBack: {
      WorkoutLocation.gym: [
        const Exercise(
          name: 'Lat Pulldowns',
          sets: 4,
          reps: 10,
          description:
              'Sit with knees under pads. Pull bar to upper chest, squeezing lats.',
        ),
        const Exercise(
          name: 'Seated Cable Rows',
          sets: 4,
          reps: 12,
          description:
              'Keep back straight. Pull handle to stomach, pinching shoulder blades.',
        ),
        const Exercise(
          name: 'Barbell Curls',
          sets: 3,
          reps: 10,
          description:
              'Stand straight. Curl bar to chest. Lower slowly without swinging.',
        ),
        const Exercise(
          name: 'Hammer Curls',
          sets: 3,
          reps: 12,
          description: 'Hold DBs with neutral grip. Curl up towards shoulders.',
        ),
        const Exercise(
          name: 'Face Pulls',
          sets: 3,
          reps: 15,
          description:
              'Pull rope to forehead, keeping elbows high. Squeeze rear delts.',
        ),
        const Exercise(
          name: 'T-Bar Rows',
          sets: 4,
          reps: 10,
          description:
              'Hinge at hips. Pull weight to chest. Keep spine neutral.',
        ),
        const Exercise(
          name: 'Deadlifts',
          sets: 3,
          reps: 6,
          description:
              'Lift bar from floor to hip level. Keep back flat and chest up.',
        ),
        const Exercise(
          name: 'Preacher Curls',
          sets: 3,
          reps: 12,
          description:
              'Use preacher bench. Curl bar up and lower fully. Isolate biceps.',
        ),
        const Exercise(
          name: 'Single Arm Dumbbell Row',
          sets: 3,
          reps: 12,
          description:
              'Knee on bench. Pull dumbbell to hip. Keep back parallel to floor.',
        ),
        const Exercise(
          name: 'Cable Bicep Curls',
          sets: 3,
          reps: 15,
          description:
              'Stand facing stack. Curl bar upwards with steady tempo.',
        ),
        const Exercise(
          name: 'Chin-ups',
          sets: 3,
          reps: 8,
          description:
              'Palms facing you. Pull chin over bar. Full range of motion.',
        ),
        const Exercise(
          name: 'Dumbbell Shrugs',
          sets: 4,
          reps: 15,
          description: 'Lift shoulders to ears. Hold briefly, then lower.',
        ),
        const Exercise(
          name: 'Straight Arm Pulldowns',
          sets: 3,
          reps: 12,
          description: 'Arms straight. Push bar down to thighs. Focus on lats.',
        ),
      ],
      WorkoutLocation.home: [
        const Exercise(
          name: 'Dumbbell Rows',
          sets: 4,
          reps: 12,
          description:
              'Bend forward. Pull weights to hips. Maintain flat back.',
        ),
        const Exercise(
          name: 'Dumbbell Curls',
          sets: 4,
          reps: 12,
          description:
              'Curl weights to shoulders. Keep elbows pinned to sides.',
        ),
        const Exercise(
          name: 'Renegade Rows',
          sets: 3,
          reps: 10,
          description:
              'Push-up position. Row one dumbbell to hip while balancing.',
        ),
        const Exercise(
          name: 'Resistance Band Pull Aparts',
          sets: 3,
          reps: 15,
          description:
              'Hold band in front. Pull hands apart until band touches chest.',
        ),
        const Exercise(
          name: 'Door Frame Rows',
          sets: 3,
          reps: 12,
          description: 'Hold door frame. Lean back and pull yourself forward.',
        ),
        const Exercise(
          name: 'Dumbbell Reverse Flys',
          sets: 3,
          reps: 12,
          description:
              'Bent over. Raise arms to sides like wings. Squeeze rear delts.',
        ),
        const Exercise(
          name: 'Supermans',
          sets: 3,
          reps: 15,
          description: 'Lie on stomach. Lift arms and legs simultaneously.',
        ),
        const Exercise(
          name: 'Concentration Curls',
          sets: 3,
          reps: 12,
          description:
              'Sit with elbow on inner thigh. Curl weight up thoroughly.',
        ),
        const Exercise(
          name: 'Zottman Curls',
          sets: 3,
          reps: 10,
          description:
              'Curl up with palms up. Rotate palms down and lower slowly.',
        ),
        const Exercise(
          name: 'Towel Rows (Door anchor)',
          sets: 4,
          reps: 12,
          description: 'Wrap towel around door knob. Pull body towards door.',
        ),
        const Exercise(
          name: 'Incline Dumbbell Hammer Curls',
          sets: 3,
          reps: 12,
          description:
              'Seated incline. Curl with neutral grip. Stretch biceps.',
        ),
      ],
      WorkoutLocation.calisthenics: [
        const Exercise(
          name: 'Pull-ups',
          sets: 4,
          reps: 8,
          description: 'Palms away. Pull chin over bar. Engage back muscles.',
        ),
        const Exercise(
          name: 'Chin-ups',
          sets: 4,
          reps: 8,
          description: 'Palms facing you. Pull up to bar. Focus on biceps.',
        ),
        const Exercise(
          name: 'Inverted Rows',
          sets: 4,
          reps: 12,
          description:
              'Hang under a bar/table. Pull chest to bar. Keep body straight.',
        ),
        const Exercise(
          name: 'Bodyweight Bicep Curls',
          sets: 3,
          reps: 10,
          description:
              'Using low bar/rings, lean back and curl body towards hands.',
        ),
        const Exercise(
          name: 'Scapular Pull-ups',
          sets: 3,
          reps: 12,
          description:
              'Hang from bar. Shrug shoulders down without bending elbows.',
        ),
        const Exercise(
          name: 'Australian Pull-ups',
          sets: 3,
          reps: 12,
          description: 'Another name for Inverted Rows. Pull chest to bar.',
        ),
        const Exercise(
          name: 'Commando Pull-ups',
          sets: 3,
          reps: 8,
          description:
              'Sideways grip on bar. Pull head to one side, then other.',
        ),
        const Exercise(
          name: 'Negative Pull-ups',
          sets: 3,
          reps: 6,
          description:
              'Jump to top position. Lower yourself as slowly as possible.',
        ),
        const Exercise(
          name: 'Door Pull-ins',
          sets: 3,
          reps: 15,
          description: 'Hold door handles. Squat and pull chest to door.',
        ),
        const Exercise(
          name: 'Superman Holds',
          sets: 3,
          reps: 30,
          description:
              'Hold superman position for 30 seconds to strengthen lower back.',
        ),
      ],
    },

    // ---------------- TRICEP & CHEST ----------------
    WorkoutArea.tricepChest: {
      WorkoutLocation.gym: [
        const Exercise(
          name: 'Bench Press',
          sets: 4,
          reps: 8,
          description:
              'Lie on bench. Lower bar to mid-chest. Press up explosively.',
        ),
        const Exercise(
          name: 'Incline Dumbbell Press',
          sets: 3,
          reps: 10,
          description: 'Set bench to 30-45°. Press DBs up from shoulders.',
        ),
        const Exercise(
          name: 'Tricep Pushdowns',
          sets: 4,
          reps: 12,
          description:
              'Keep elbows at sides. Push cable attachment down fully.',
        ),
        const Exercise(
          name: 'Overhead Tricep Extensions',
          sets: 3,
          reps: 12,
          description:
              'Lift weight overhead. Lower behind head, extending elbows.',
        ),
        const Exercise(
          name: 'Cable Flys',
          sets: 3,
          reps: 15,
          description:
              'Stand in middle. Pull handles together in hugging motion.',
        ),
        const Exercise(
          name: 'Dips',
          sets: 3,
          reps: 10,
          description:
              'Lower body until elbows at 90°. Push back up. Lean for chest.',
        ),
        const Exercise(
          name: 'Skull Crushers',
          sets: 3,
          reps: 10,
          description:
              'Lie on bench. Lower bar to forehead. Extend arms back up.',
        ),
        const Exercise(
          name: 'Pec Deck Machine',
          sets: 3,
          reps: 15,
          description: 'Sit and bring arms together. Squeeze chest at center.',
        ),
        const Exercise(
          name: 'Close Grip Bench Press',
          sets: 3,
          reps: 8,
          description:
              'Hands shoulder-width. Lower to chest. Emphasizes triceps.',
        ),
        const Exercise(
          name: 'Decline Press',
          sets: 3,
          reps: 10,
          description:
              'Head lower than hips. Press weight up. Targets lower chest.',
        ),
        const Exercise(
          name: 'Single Arm Tricep Extension',
          sets: 3,
          reps: 12,
          description:
              'Use cable/DB. Extend arm downwards/overhead individually.',
        ),
      ],
      WorkoutLocation.home: [
        const Exercise(
          name: 'Push-ups',
          sets: 4,
          reps: 15,
          description:
              'Plank position. Lower chest to floor. Push up. Keep core tight.',
        ),
        const Exercise(
          name: 'Dumbbell Floor Press',
          sets: 4,
          reps: 10,
          description: 'Lie on floor. Press dumbbells up until arms extended.',
        ),
        const Exercise(
          name: 'Dumbbell Tricep Kickbacks',
          sets: 3,
          reps: 12,
          description: 'Bent over. Extend arm back parallel to floor.',
        ),
        const Exercise(
          name: 'Overhead Dumbbell Extension',
          sets: 3,
          reps: 12,
          description: 'Hold DB with both hands overhead. Lower behind head.',
        ),
        const Exercise(
          name: 'Chair Dips',
          sets: 3,
          reps: 12,
          description:
              'Hands on chair behind you. Lower hips. Push up with triceps.',
        ),
        const Exercise(
          name: 'Dumbbell Flys',
          sets: 3,
          reps: 12,
          description:
              'Lie on floor/bench. Open arms wide. Bring weights together.',
        ),
        const Exercise(
          name: 'Diamond Push-ups',
          sets: 3,
          reps: 10,
          description: 'Hands close together forming diamond. Target triceps.',
        ),
        const Exercise(
          name: 'Close Grip Dumbbell Press',
          sets: 3,
          reps: 12,
          description: 'Press DBs keeping them touching each other.',
        ),
        const Exercise(
          name: 'Decline Push-ups (Feet elevated)',
          sets: 3,
          reps: 10,
          description: 'Feet on chair. Hands on floor. Targets upper chest.',
        ),
        const Exercise(
          name: 'Incline Push-ups (Hands elevated)',
          sets: 3,
          reps: 15,
          description:
              'Hands on chai/bench. Easier variation. Targets lower chest.',
        ),
      ],
      WorkoutLocation.calisthenics: [
        const Exercise(
          name: 'Standard Push-ups',
          sets: 4,
          reps: 15,
          description: 'Classic push-up. Chest to floor, full extension.',
        ),
        const Exercise(
          name: 'Diamond Push-ups',
          sets: 3,
          reps: 10,
          description: 'Hands together under chest. Focus on triceps.',
        ),
        const Exercise(
          name: 'Dips',
          sets: 4,
          reps: 8,
          description: 'Parallel bars. Lower until shoulders below elbows.',
        ),
        const Exercise(
          name: 'Pike Push-ups',
          sets: 3,
          reps: 8,
          description:
              'Hips high (V-shape). Lower head to floor. Simulates overhead press.',
        ),
        const Exercise(
          name: 'Wide Grip Push-ups',
          sets: 3,
          reps: 12,
          description: 'Hands wider than shoulders. Focuses more on chest.',
        ),
        const Exercise(
          name: 'Archer Push-ups',
          sets: 3,
          reps: 8,
          description:
              'Shift weight to one side while extending other arm straight.',
        ),
        const Exercise(
          name: 'Explosive Push-ups',
          sets: 3,
          reps: 8,
          description:
              'Push hard enough for hands to leave ground (clap optional).',
        ),
        const Exercise(
          name: 'Pseudo Planche Push-ups',
          sets: 3,
          reps: 8,
          description:
              'Hands closer to hips. Lean forward. Hard shoulder focus.',
        ),
        const Exercise(
          name: 'Bodyweight Tricep Extensions',
          sets: 3,
          reps: 10,
          description: 'Plank on elbows. Push up to hands using triceps.',
        ),
        const Exercise(
          name: 'Decline Push-ups',
          sets: 3,
          reps: 12,
          description: 'Feet elevated. Increases load on upper body.',
        ),
      ],
    },

    // ---------------- LEGS & SHOULDERS ----------------
    WorkoutArea.legsShoulders: {
      WorkoutLocation.gym: [
        const Exercise(
          name: 'Squats',
          sets: 4,
          reps: 8,
          description:
              'Bar on upper back. Squat deep keeping chest up. Drive up.',
        ),
        const Exercise(
          name: 'Leg Press',
          sets: 3,
          reps: 10,
          description:
              'Feet shoulder-width. Lower sled until knees 90°. Push back.',
        ),
        const Exercise(
          name: 'Overhead Press',
          sets: 4,
          reps: 8,
          description: 'Press bar from shoulders to overhead. Lock out.',
        ),
        const Exercise(
          name: 'Lateral Raises',
          sets: 4,
          reps: 15,
          description:
              'Raise DBs to sides until shoulder height. Slight elbow bend.',
        ),
        const Exercise(
          name: 'Leg Extensions',
          sets: 3,
          reps: 12,
          description: 'Extend legs against pad. Squeeze quads at top.',
        ),
        const Exercise(
          name: 'Romanian Deadlifts',
          sets: 3,
          reps: 10,
          description:
              'Slight knee bend. Hinge at hips. Feel hamstring stretch.',
        ),
        const Exercise(
          name: 'Lunges',
          sets: 3,
          reps: 12,
          description: 'Step forward, lower back knee to ground. Push back.',
        ),
        const Exercise(
          name: 'Seated Dumbbell Press',
          sets: 3,
          reps: 10,
          description: 'Sit with back support. Press DBs overhead.',
        ),
        const Exercise(
          name: 'Front Raises',
          sets: 3,
          reps: 12,
          description: 'Lift DBs in front to shoulder height.',
        ),
        const Exercise(
          name: 'Seated Leg Curls',
          sets: 3,
          reps: 12,
          description: 'Curl legs back against pad. Squeeze hamstrings.',
        ),
        const Exercise(
          name: 'Standing Calf Raises',
          sets: 4,
          reps: 15,
          description: 'Raise heels high. Lower until stretch felt.',
        ),
        const Exercise(
          name: 'Face Pulls',
          sets: 3,
          reps: 15,
          description: 'Pull rope to face. Great for rear delts and posture.',
        ),
      ],
      WorkoutLocation.home: [
        const Exercise(
          name: 'Goblet Squats',
          sets: 4,
          reps: 12,
          description: 'Hold one DB at chest. Squat down.',
        ),
        const Exercise(
          name: 'Dumbbell Lunges',
          sets: 3,
          reps: 12,
          description: 'Hold DBs by sides. Step and lunge.',
        ),
        const Exercise(
          name: 'Dumbbell Shoulder Press',
          sets: 4,
          reps: 10,
          description: 'Stand or sit. Press DBs overhead.',
        ),
        const Exercise(
          name: 'Lateral Raises',
          sets: 4,
          reps: 15,
          description: 'Raise DBs to side. Isolate side delts.',
        ),
        const Exercise(
          name: 'Calf Raises',
          sets: 4,
          reps: 20,
          description: 'Stand on edge of step. Raise and lower heels.',
        ),
        const Exercise(
          name: 'Bulgarian Split Squats',
          sets: 3,
          reps: 10,
          description: 'One foot on bench behind. Squat with front leg.',
        ),
        const Exercise(
          name: 'Glute Bridges',
          sets: 3,
          reps: 15,
          description: 'Lie on back. Lift hips to ceiling. Squeeze glutes.',
        ),
        const Exercise(
          name: 'Arnold Press',
          sets: 3,
          reps: 10,
          description: 'Palms face you at bottom, rotate out as you press up.',
        ),
        const Exercise(
          name: 'Front Dumbbell Raises',
          sets: 3,
          reps: 12,
          description: 'Lift DB in front to eye level.',
        ),
        const Exercise(
          name: 'Step-ups',
          sets: 3,
          reps: 12,
          description: 'Step ono chair/box. Drive up with leading leg.',
        ),
      ],
      WorkoutLocation.calisthenics: [
        const Exercise(
          name: 'Pistol Squats (or assisted)',
          sets: 3,
          reps: 6,
          description: 'Single leg squat. Use support if needed.',
        ),
        const Exercise(
          name: 'Lunges',
          sets: 4,
          reps: 15,
          description: 'Walking or static bodyweight lunges.',
        ),
        const Exercise(
          name: 'Handstand Push-ups (or Pike)',
          sets: 3,
          reps: 6,
          description: 'Vertical push-up against wall. Or pike push-ups.',
        ),
        const Exercise(
          name: 'Jump Squats',
          sets: 3,
          reps: 12,
          description: 'Squat and jump up explosively.',
        ),
        const Exercise(
          name: 'Calf Raises',
          sets: 4,
          reps: 20,
          description: 'Single leg or both legs. High volume.',
        ),
        const Exercise(
          name: 'Bulgarian Split Squats',
          sets: 3,
          reps: 10,
          description: 'Rear foot elevated. Deep knee bend.',
        ),
        const Exercise(
          name: 'Wall Sit',
          sets: 3,
          reps: 45,
          description:
              'Sit against wall with thighs parallel. Hold for seconds.',
        ),
        const Exercise(
          name: 'Glute Bridges',
          sets: 3,
          reps: 20,
          description: 'Lift hips. Squeeze glutes hard at top.',
        ),
        const Exercise(
          name: 'Side Lunges',
          sets: 3,
          reps: 12,
          description: 'Step wide to side. Squat on one leg, other straight.',
        ),
        const Exercise(
          name: 'Bear Crawl',
          sets: 3,
          reps: 30,
          description:
              'Crawl on hands and feet. Keep back flat. Time in seconds.',
        ),
      ],
    },

    // ---------------- STRETCHING ----------------
    WorkoutArea.stretching: {
      // Sharing same pool for all locations for now
      WorkoutLocation.gym: _stretchingPool,
      WorkoutLocation.home: _stretchingPool,
      WorkoutLocation.calisthenics: _stretchingPool,
    },
  };

  static const List<Exercise> _stretchingPool = [
    Exercise(
      name: 'Hamstring Stretch',
      sets: 2,
      reps: 30,
      description: 'Reach for toes keeping legs straight. Hold 30s.',
    ),
    Exercise(
      name: 'Quad Stretch',
      sets: 2,
      reps: 30,
      description: 'Pull heel to glute. Push hips forward. Hold 30s.',
    ),
    Exercise(
      name: 'Shoulder Cross-Body Stretch',
      sets: 2,
      reps: 30,
      description: 'Pull arm across chest. Hold 30s.',
    ),
    Exercise(
      name: 'Tricep Stretch',
      sets: 2,
      reps: 30,
      description: 'Pull elbow behind head. Hold 30s.',
    ),
    Exercise(
      name: 'Child’s Pose',
      sets: 2,
      reps: 30,
      description: 'Kneel and reach hands forward on floor. Relax back.',
    ),
    Exercise(
      name: 'Cobra Stretch',
      sets: 2,
      reps: 30,
      description: 'Lie on stomach. Push chest up. Stretch abs.',
    ),
    Exercise(
      name: 'Butterfly Stretch',
      sets: 2,
      reps: 30,
      description: 'Feet together. Push knees down. Stretch groin.',
    ),
    Exercise(
      name: 'Neck Rolls',
      sets: 2,
      reps: 10,
      description: 'Slowly roll head in circles to loosen neck.',
    ),
    Exercise(
      name: 'Cat-Cow Stretch',
      sets: 2,
      reps: 10,
      description: 'Arch spine up (Cat), then dip down (Cow).',
    ),
    Exercise(
      name: 'Hip Flexor Stretch',
      sets: 2,
      reps: 30,
      description: 'Lunge position. Push hips forward. Hold.',
    ),
    Exercise(
      name: 'Downward Dog',
      sets: 2,
      reps: 30,
      description:
          'Hands and feet on floor. Hips high. Stretch posterior chain.',
    ),
    Exercise(
      name: 'Pigeon Pose',
      sets: 2,
      reps: 30,
      description: 'Leg bent under front of body. Stretch glute. Hold.',
    ),
  ];

  static WorkoutPlan getPlan(WorkoutArea area, WorkoutLocation location) {
    List<Exercise> allExercises = _exercisePool[area]?[location] ?? [];

    // Pick 5 random exercises from the pool
    // If pool has fewer than 5, return all of them.
    List<Exercise> selectedExercises = _pickRandomExercises(allExercises, 5);

    return WorkoutPlan(
      area: area,
      location: location,
      exercises: selectedExercises,
    );
  }

  static List<Exercise> _pickRandomExercises(List<Exercise> pool, int count) {
    if (pool.isEmpty) return [];
    if (pool.length <= count) return List.from(pool);

    final random = Random();
    final List<Exercise> picked = [];
    final List<int> pickedIndices = [];

    while (picked.length < count) {
      final index = random.nextInt(pool.length);
      if (!pickedIndices.contains(index)) {
        pickedIndices.add(index);
        picked.add(pool[index]);
      }
    }

    return picked;
  }
}

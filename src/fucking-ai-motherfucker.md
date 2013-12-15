My very first 2D platformer AI <3

States:
  - Idle
  - Jump
  - Walk to ladder
  - Climb up ladder
  - Follow / Attack player

Idle: Walk left or right every now and then.

Following steps:
  - Every second (or so) check the distance to the player / package. If it's /
    he's "in sight", decide the next action

    - If the object is underneath, walk into that direction. If the enemy can
      (probably) reach the next lower platform by jumping, then jump. Otherwise,
      fall down like a goddamn lemming. Then check again.

    - If the object is further up, check whether the enemy could reach the plat-
      form the object is on by jumping. If yes, walk to the edge of the platform
      and jump. If not, look for a ladder, walk there and climb it up. Then, check again.

    - If the object is on the same platform, and he has the package, run in his direction.
      If he doesn't have the package, focus on the package instead. Every 500ms (or so),
      check for the next action (e.g. turn around or move to the platform the player
      is now standing on)

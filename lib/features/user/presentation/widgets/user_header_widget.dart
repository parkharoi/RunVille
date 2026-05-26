import 'package:flutter/material.dart';

import '../../domain/user_profile.dart';

class UserHeaderWidget extends StatelessWidget {
  const UserHeaderWidget({required this.userProfile, super.key});

  final UserProfile userProfile;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Row(
            children: [
              // 프로필 이미지
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Theme.of(context).colorScheme.primaryContainer,
                ),
                child:
                    userProfile.profileImageUrl != null
                        ? ClipRRect(
                          borderRadius: BorderRadius.circular(40),
                          child: Image.network(
                            userProfile.profileImageUrl!,
                            fit: BoxFit.cover,
                          ),
                        )
                        : Icon(
                          Icons.person,
                          size: 40,
                          color: Theme.of(context).colorScheme.primary,
                        ),
              ),
              const SizedBox(width: 16),
              // 유저 정보
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      userProfile.nickname,
                      style: Theme.of(context).textTheme.headlineSmall
                          ?.copyWith(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFF8C42),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        'LEVEL ${userProfile.level}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      userProfile.runnerType,
                      style: Theme.of(
                        context,
                      ).textTheme.bodySmall?.copyWith(color: Colors.grey),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class UWarriorEnemyGameplayAbility : UWarriorGameplayAbility
{
	TWeakObjectPtr<AWarriorEnemyCharacter> CachedWarriorEnemeyCharacter;

	UFUNCTION(BlueprintPure, Category = "Warrior|Ability")
	AWarriorEnemyCharacter GetEnemyCharacterFromActorInfo() {
		if (!CachedWarriorEnemeyCharacter.IsValid())
		{
			CachedWarriorEnemeyCharacter = Cast<AWarriorEnemyCharacter>(AvatarActorFromActorInfo);
		}

		return CachedWarriorEnemeyCharacter;
	}

	UFUNCTION(BlueprintPure, Category = "Warrior|Ability")
	UEnemyCombatComponent GetEnemyCombatComponentFromActorInfo() {
		return UEnemyCombatComponent::Get(AvatarActorFromActorInfo);
	}
}

class UDataAsset_EnemyStartupData : UDataAsset_StartupDataBase
{
	UPROPERTY(Category = "StartupData")
	TArray<TSubclassOf<UWarriorEnemyGameplayAbility>> EnemyStartupAbilities;

	void GiveToAbilitySystemComponent(UAngelscriptAbilitySystemComponent InWarriorAbilitySystem, int32 ApplyLevel = 1) override
	{
		Super::GiveToAbilitySystemComponent(InWarriorAbilitySystem, ApplyLevel);

		for (auto Ability : EnemyStartupAbilities)
		{
			if (Ability == nullptr)
				continue;

			FGameplayAbilitySpec AbilitySpec(Ability);
			AbilitySpec.SourceObject = InWarriorAbilitySystem.Avatar;
			AbilitySpec.Level = ApplyLevel;

			InWarriorAbilitySystem.GiveAbility(AbilitySpec);
		}
	}
}
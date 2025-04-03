class UDataAsset_HeroStartupData : UDataAsset_StartupDataBase
{
	UPROPERTY(Category = "StartupData", meta = (TitleProperty = "InputTag"))
	TArray<FWarriorHeroAbilitySet> HeroStartupAbilitySets;

	void GiveToAbilitySystemComponent(UWarriorAbilitySystemComponent InWarriorAbilitySystem, int32 ApplyLevel = 1) override
	{
		Super::GiveToAbilitySystemComponent(InWarriorAbilitySystem, ApplyLevel);

		for (FWarriorHeroAbilitySet AbilitySet : HeroStartupAbilitySets)
		{
			if (!AbilitySet.IsValid())
				continue;

			FGameplayAbilitySpec AbilitySpec(AbilitySet.AbilityToGrant);
			AbilitySpec.SourceObject = InWarriorAbilitySystem.Avatar;
			AbilitySpec.Level = ApplyLevel;
			AbilitySpec.DynamicAbilityTags.AddTag(AbilitySet.InputTag);

			InWarriorAbilitySystem.GiveAbility(AbilitySpec);
		}
	}
}
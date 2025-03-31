

class UWarriorHeroGameplayAbility : UWarriorGameplayAbility
{
	TWeakObjectPtr<AWarriorHeroCharacter> CachedWarriorHeroCharacter;
	TWeakObjectPtr<AWarriorHeroController> CachedWarriorHeroController;

	UFUNCTION(BlueprintCallable, Category = "Warrior|Ability")
	AWarriorHeroCharacter GetHeroCharacterFromActorInfo() {
		if (!CachedWarriorHeroCharacter.IsValid())
		{
			CachedWarriorHeroCharacter = Cast<AWarriorHeroCharacter>(ActorInfo.AvatarActor);
		}

		return CachedWarriorHeroCharacter;
	}

	UFUNCTION(BlueprintCallable, Category = "Warrior|Ability")
	AWarriorHeroController GetHeroControllerFromActorInfo(){
		if (!CachedWarriorHeroController.IsValid())
		{
			CachedWarriorHeroController = Cast<AWarriorHeroController>(ActorInfo.PlayerController);
		}

		return CachedWarriorHeroController;
	}

	// UFUNCTION(BlueprintCallable, Category = "Warrior|Ability")
	// UHeroCombatComponent GetHeroCombatComponentFromActorInfo();
}
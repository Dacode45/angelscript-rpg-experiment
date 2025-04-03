class AWarriorEnemyCharacter : AWarriorBaseCharacter
{
	UPROPERTY(DefaultComponent)
	UEnemyCombatComponent EnemyCombatComponent;

	UFUNCTION(BlueprintOverride)
	void ConstructionScript()
	{
		AutoPossessAI = EAutoPossessAI::PlacedInWorldOrSpawned;

		bUseControllerRotationPitch = false;
		bUseControllerRotationRoll = false;
		bUseControllerRotationYaw = false;

		CharacterMovement.bUseControllerDesiredRotation = false;
		CharacterMovement.bOrientRotationToMovement = true;
		CharacterMovement.RotationRate = FRotator(0.f, 180.0f, 0.f);
		CharacterMovement.MaxWalkSpeed = 300.f;
		CharacterMovement.BrakingDecelerationWalking = 1000.f;
	}
}
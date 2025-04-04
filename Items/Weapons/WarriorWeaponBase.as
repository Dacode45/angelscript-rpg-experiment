delegate void FOnWeaponHitTarget(AActor HitActor);
delegate void FOnWeaponPulledFromTarget(AActor HitActor);

class AWarriorWeaponBase : AActor
{

	UPROPERTY(DefaultComponent, Category = "Weapon")
	UStaticMeshComponent WeaponMesh;

	UPROPERTY(DefaultComponent, Category = "Weapon")
	UBoxComponent WeaponCollisionBox;

	FOnWeaponHitTarget OnWeaponHitTarget;
	FOnWeaponPulledFromTarget OnWeaponPulledFromTarget;

	default WeaponCollisionBox.BoxExtent = FVector(20.0f);
	default WeaponCollisionBox.CollisionEnabled = ECollisionEnabled::NoCollision;
	default WeaponCollisionBox.OnComponentBeginOverlap.AddUFunction(this, n"OnCollisionBoxBeginOverlap");
	default WeaponCollisionBox.OnComponentEndOverlap.AddUFunction(this, n"OnCollisionBoxEndOverlap");

	UFUNCTION()
	void OnCollisionBoxBeginOverlap(UPrimitiveComponent OverlappedComponent, AActor OtherActor, UPrimitiveComponent OtherComp, int OtherBodyIndex, bool bFromSweep, const FHitResult&in SweepResult) {
		APawn WeaponOwningPawn = GetInstigator();

		check(WeaponOwningPawn != nullptr, f"Forgot to assign an instigator to the weapon {GetName()}");

		if (WeaponOwningPawn != Cast<APawn>(OtherActor))
		{
			OnWeaponHitTarget.ExecuteIfBound(OtherActor);
		}
	}

	UFUNCTION()
	void OnCollisionBoxEndOverlap(UPrimitiveComponent OverlappedComponent, AActor OtherActor, UPrimitiveComponent OtherComp, int OtherBodyIndex) {
		APawn WeaponOwningPawn = GetInstigator();

		check(WeaponOwningPawn != nullptr, f"Forgot to assign an instigator to the weapon {GetName()}");

		if (WeaponOwningPawn != Cast<APawn>(OtherActor))
		{
			OnWeaponPulledFromTarget.ExecuteIfBound(OtherActor);
		}
	}
}